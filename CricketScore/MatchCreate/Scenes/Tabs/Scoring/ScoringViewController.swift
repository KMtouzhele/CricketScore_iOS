//
//  ScoringViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation
import UIKit

protocol ScoringBusinessLogic: AnyObject {
    func getTeamPlayers(battingTeamId: String, bowlingTeamId: String, completion: @escaping () -> Void)
    func addBall(ballRequest: ScoringModel.Request.ballRequest, scoreRequest: ScoringModel.Request.scoreRequest)
    func updateSummaryData(summaryViewModel: ScoringModel.ViewModel.summaryViewModel ,ballRequest: ScoringModel.Request.ballRequest)
}

enum PickerType {
    case boundaries
    case wickets
    case extras
    case striker
    case nonStriker
    case bowler
}

class ScoringViewController: UIViewController, UpdateScoreBoard {
    var tabBar: TabBarController!
    
    //inhert from former view
    var battingTeamId: String?
    var bowlingTeamId: String?
    var matchId: String?
    
    //retrieve from database
    var battingTeamDic: [String: String]?
    var bowlingTeamDic: [String: String]?
    var battingNamesArray: [String]?
    var bowlingNamesArray: [String]?
    
    //new variables
    var interactor: ScoringBusinessLogic?
    var presenter = ScoringPresenter()
    var strikerId: String?
    var nonStrikerId: String?
    var bowlerId: String?
    var runs: Int = 0
    var result: ballType = .runs
    var overCalculator : Int = 0
    
    //constants
    let boundaries = ["4s", "6s"]
    let wickets = ["Bowled", "Caught", "Caught&Bowled", "LBW", "Hit Wicket", "Run Out", "Stumping"]
    let extras = ["No Ball", "Wide"]
    
    //pickerview
    var currentPickerType: PickerType = .boundaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = self.tabBarController as? TabBarController
        print("OverCalculator: \(overCalculator)")
        self.btnConfirm.isEnabled = false
        self.interactor = ScoringInteractor(presenter: self.presenter)
        self.presenter.scoringViewController = self
        self.interactor?.getTeamPlayers(battingTeamId: self.battingTeamId!, bowlingTeamId: self.bowlingTeamId!) { [weak self] in
            self?.tabBar.summaryViewModel.battingTeamId = (self?.battingTeamId)!
            self?.tabBar.summaryViewModel.bowlingTeamId = (self?.bowlingTeamId)!
            self?.initializeViewStatus()
            self?.convertDicToArray()
            self?.enableButtons()
        }
    }
    
    func displayScoreBoard(viewModel: ScoringModel.ViewModel.score) {
        overCalculator = viewModel.overCalculator
        strikerId = viewModel.strikerId
        nonStrikerId = viewModel.nonStrikerId

        let strikerName = battingTeamDic![strikerId!]
        let nonStrikerNamr = battingTeamDic![nonStrikerId!]
        
        selectStriker.setTitle(strikerName, for: .normal)
        selectNonStriker.setTitle(nonStrikerNamr, for: .normal)
        
        runsStriker.text = String(viewModel.runsStriker)
        ballsFacedStriker.text = String(viewModel.ballsFacedStriker)
        fourStriker.text = String(viewModel.foursStriker)
        sixStriker.text = String(viewModel.sixsStriker)
        runsNonStriker.text = String(viewModel.runsNonStriker)
        ballsFacedNonStriker.text = String(viewModel.ballsFacedNonStriker)
        fourNonStriker.text = String(viewModel.foursNonStriker)
        sixNonStriker.text = String(viewModel.sixsNonStriker)
        totalWickets.text = String(viewModel.wickets)
        runsLost.text = String(viewModel.runsLost)
        ballsDelivered.text = String(viewModel.ballsDelivered)
    }
    
    func setDefaultStrikerSelection(){
        selectStriker.setTitle("Striker", for: .normal)
        strikerId = nil
        updateBtnConfirmStatus()
    }
    
    func setDefaultNonStrikerSelection(){
        selectNonStriker.setTitle("Non-Striker", for: .normal)
        nonStrikerId = nil
        updateBtnConfirmStatus()
    }
    
    func setDefaultBowlerSelection(){
        selectBowler.setTitle("Bowler", for: .normal)
        bowlerId = nil
        updateBtnConfirmStatus()
    }
    
    func removeStrikerFromDic(strikerId: String){
        var dic = self.battingTeamDic
        dic?.removeValue(forKey: strikerId)
        self.battingTeamDic = dic
        convertDicToArray()
    }
    
    func removeBowlerFromDic(bowlerId: String){
        var dic = self.bowlingTeamDic
        dic?.removeValue(forKey: bowlerId)
        self.bowlingTeamDic = dic
        convertDicToArray()
    }
    
    func initializeStrikerScore(){
        runsStriker.text = "0"
        ballsFacedStriker.text = "0"
        fourStriker.text = "0"
        sixStriker.text = "0"
    }
    
    func initializeBowlerScore(){
        totalWickets.text = "0"
        runsLost.text = "0"
        ballsDelivered.text = "0"
    }
    
    private func convertDicToArray(){
        guard let battingTeamDic = self.battingTeamDic else {
            print("BattingTeamDic is nil")
            return
        }
        self.battingNamesArray = Array(battingTeamDic.values)
        
        guard let bowlingTeamDic = self.bowlingTeamDic else {
            print("BowlingTeamDic is nil")
            return
        }
        self.bowlingNamesArray = Array(bowlingTeamDic.values)
    }
    
    private func updatePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func initializeViewStatus(){
        setDefaultStrikerSelection()
        setDefaultNonStrikerSelection()
        setDefaultBowlerSelection()
        stepper.value = 0
        runsTextField.text = String(Int(stepper.value))
        pickerView.isHidden = true
    }
    
    private func enableButtons(){
        selectStriker.isEnabled = true
        selectNonStriker.isEnabled = true
        selectBowler.isEnabled = true
    }
    
    private func updateBtnConfirmStatus(){
        if strikerId != nil && nonStrikerId != nil && bowlerId != nil {
            btnConfirm.isEnabled = true
        } else {
            btnConfirm.isEnabled = false
        }
    }
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func btnConfirm(_ sender: UIButton) {
        self.runs = Int(stepper.value)
        let ballRequest = ScoringModel.Request.ballRequest(
            matchId: self.matchId!,
            battingTeamId: self.battingTeamId!,
            bowlingTeamId: self.bowlingTeamId!,
            strikerId: self.strikerId!,
            nonStrikerId: self.nonStrikerId!,
            bowlerId: self.bowlerId!,
            runs: Int(stepper.value),
            result: self.result
        )
        let runsStrikerValue = Int(runsStriker.text!)
        let ballsFacedStrikerValue = Int(ballsFacedStriker.text!)
        let foursStrikerValue = Int(fourStriker.text!)
        let sixesStrikerValue = Int(sixStriker.text!)
        let runsNonStrikerValue = Int(runsNonStriker.text!)
        let ballsFacedNonStrikerValue = Int(ballsFacedNonStriker.text!)
        let foursNonStrikerValue = Int(fourNonStriker.text!)
        let sixesNonStrikerValue = Int(sixNonStriker.text!)
        let wicketsValue = Int(totalWickets.text!)
        let runsLostValue = Int(runsLost.text!)
        let ballsDeliveredValue = Int(ballsDelivered.text!)

        let scoreRequest = ScoringModel.Request.scoreRequest(
            overCalculator: overCalculator,
            strikerId: strikerId!,
            nonStrikerId: nonStrikerId!,
            runsStriker: runsStrikerValue!,
            ballsFacedStriker: ballsFacedStrikerValue!,
            foursStriker: foursStrikerValue!,
            sixsStriker: sixesStrikerValue!,
            runsNonStriker: runsNonStrikerValue!,
            ballsFacedNonStriker: ballsFacedNonStrikerValue!,
            foursNonStriker: foursNonStrikerValue!,
            sixsNonStriker: sixesNonStrikerValue!,
            wickets: wicketsValue!,
            runsLost: runsLostValue!,
            ballsDelivered: ballsDeliveredValue!
        )
        interactor?.addBall(ballRequest: ballRequest, scoreRequest: scoreRequest)
        
        interactor?.updateSummaryData(summaryViewModel: tabBar.summaryViewModel, ballRequest: ballRequest)
        extraDiselected()
        boundaryDiselected()
        wicketDiselected()
        stepper.value = 0
        runsTextField.text = String(Int(stepper.value))
        result = .runs
        print("OverCalculater: \(overCalculator)")
        print("Updated summary: \(String(describing: tabBar.summaryViewModel))")
        updateBtnConfirmStatus()
    }
    @IBAction func btnReset(_ sender: UIButton) {
        extraDiselected()
        boundaryDiselected()
        wicketDiselected()
        initializeStepper()
        result = .runs
    }
    //Select Boundaries
    @IBOutlet weak var selectBoundaries: UIButton!
    @IBAction func selectBoundaries(_ sender: UIButton) {
        currentPickerType = .boundaries
        pickerView.isHidden = false
        updatePickerView()
    }
    
    @IBOutlet weak var selectWicket: UIButton!
    @IBAction func selectWicket(_ sender: UIButton) {
        currentPickerType = .wickets
        pickerView.isHidden = false
        updatePickerView()
    }
    
    @IBOutlet weak var selectExtras: UIButton!
    @IBAction func selectExtras(_ sender: UIButton) {
        currentPickerType = .extras
        pickerView.isHidden = false
        updatePickerView()
    }
    
    @IBOutlet weak var selectStriker: UIButton!
    @IBAction func selectStriker(_ sender: UIButton) {
        currentPickerType = .striker
        pickerView.isHidden = false
        updatePickerView()
    }
    
    @IBOutlet weak var selectNonStriker: UIButton!
    @IBAction func selectNonStriker(_ sender: UIButton) {
        currentPickerType = .nonStriker
        pickerView.isHidden = false
        updatePickerView()
    }
    
    @IBOutlet weak var selectBowler: UIButton!
    @IBAction func selectBowler(_ sender: UIButton) {
        currentPickerType = .bowler
        pickerView.isHidden = false
        updatePickerView()
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var runsTextField: UITextField!
    
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperTapped(_ sender: UIStepper) {
        runsTextField.text = "\(Int(sender.value))"
        wicketDiselected()
        extraDiselected()
        boundaryDiselected()
        self.result = .runs
        print("Ball result is \(String(describing: self.result))")
        
    }
    
    //ScoreBoard View Items
    @IBOutlet weak var runsStriker: UILabel!
    @IBOutlet weak var ballsFacedStriker: UILabel!
    @IBOutlet weak var fourStriker: UILabel!
    @IBOutlet weak var sixStriker: UILabel!
    @IBOutlet weak var runsNonStriker: UILabel!
    @IBOutlet weak var ballsFacedNonStriker: UILabel!
    @IBOutlet weak var fourNonStriker: UILabel!
    @IBOutlet weak var sixNonStriker: UILabel!
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var runsLost: UILabel!
    @IBOutlet weak var ballsDelivered: UILabel!
    
}

extension ScoringViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currentPickerType {
        case .boundaries:
            return boundaries.count
        case .wickets:
            return wickets.count
        case .extras:
            return extras.count
        case .striker, .nonStriker:
            return battingNamesArray!.count
        case .bowler:
            return bowlingNamesArray!.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch currentPickerType {
        case .boundaries:
            return boundaries[row]
        case .wickets:
            return wickets[row]
        case .extras:
            return extras[row]
        case .striker, .nonStriker:
            return battingNamesArray![row]
        case .bowler:
            return bowlingNamesArray![row]
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentPickerType {
        case .boundaries:
            selectBoundaries.setTitle(boundaries[row], for: .normal)
            switch boundaries[row] {
            case "4s": self.result = ballType.fourBoundary
            case "6s": self.result = ballType.sixBoundary
            default: self.result = ballType.empty
            }
            boundarySelected()
            initializeStepper()
            wicketDiselected()
            extraDiselected()
            updateBtnConfirmStatus()
            print("Ball result is \(String(describing: self.result))")
        
        case.wickets:
            selectWicket.setTitle(wickets[row], for: .normal)
            wicketSelected()
            switch wickets[row] {
            case "Bowled": self.result = ballType.bowled
            case "Caught": self.result = ballType.caught
            case "Caught&Bowled": self.result = ballType.caughtBowled
            case "LBW": self.result = ballType.lbw
            case "Hit Wicket": self.result = ballType.hitWicket
            case "Run Out": self.result = ballType.runOut
            case "Stumping": self.result = ballType.stumping
            default: self.result = ballType.empty
            }
            initializeStepper()
            boundaryDiselected()
            extraDiselected()
            updateBtnConfirmStatus()
            print("Ball result is \(String(describing: self.result))")
        
        case.extras:
            selectExtras.setTitle(extras[row], for: .normal)
            extraSelected()
            switch extras[row] {
            case "No Ball": self.result = ballType.noBall
            case "Wide": self.result = ballType.wide
            default: self.result = ballType.empty
            }
            initializeStepper()
            boundaryDiselected()
            wicketDiselected()
            updateBtnConfirmStatus()
            print("Ball result is \(String(describing: self.result))")
        
        case .striker:
            selectStriker.setTitle(battingNamesArray![row], for: .normal)
            if let selectedStrikerName = battingNamesArray?[row]{
                for (key, value) in battingTeamDic ?? [:] {
                    if value == selectedStrikerName {
                        self.strikerId = key
                        break
                    }
                }
            }
            tabBar.summaryViewModel.strikerName = battingTeamDic?[self.strikerId!] ?? "Not Found"
            updateBtnConfirmStatus()
            print("Selected Striker: \(String(describing: self.strikerId))")
            
        case .nonStriker:
            selectNonStriker.setTitle(battingNamesArray![row], for: .normal)
            if let selectedNonStrikerName = battingNamesArray?[row]{
                for (key, value) in battingTeamDic ?? [:] {
                    if value == selectedNonStrikerName {
                        self.nonStrikerId = key
                        break
                    }
                }
            }
            tabBar.summaryViewModel.nonStrikerName = battingTeamDic?[self.nonStrikerId!] ?? "Not Found"
            updateBtnConfirmStatus()
            print("Selected NonStriker: \(String(describing: self.nonStrikerId))")
        case .bowler:
            selectBowler.setTitle(bowlingNamesArray![row], for: .normal)
            if let selectedBowlerName = bowlingNamesArray?[row]{
                for (key, value) in bowlingTeamDic ?? [:] {
                    if value == selectedBowlerName {
                        self.bowlerId = key
                        break
                    }
                }
            }
            tabBar.summaryViewModel.bowlerName = bowlingTeamDic?[self.bowlerId!] ?? "Not Found"
            updateBtnConfirmStatus()
            print("Selected Bowler: \(String(describing: self.bowlerId))")
        }
        pickerView.isHidden = true
    }
    
    func wicketSelected(){
        selectWicket.setTitleColor(.white, for: .normal)
        selectWicket.backgroundColor = .systemBlue
        selectWicket.layer.cornerRadius = 10
        selectWicket.clipsToBounds = true
    }
    
    func wicketDiselected(){
        selectWicket.setTitleColor(.systemBlue, for: .normal)
        selectWicket.backgroundColor = nil
        selectWicket.layer.cornerRadius = 0
        selectWicket.clipsToBounds = false
        selectWicket.setTitle("Select Wicket", for: .normal)
    }
    
    func boundarySelected(){
        selectBoundaries.setTitleColor(.white, for: .normal)
        selectBoundaries.backgroundColor = .systemBlue
        selectBoundaries.layer.cornerRadius = 10
        selectBoundaries.clipsToBounds = true
    }
    
    func boundaryDiselected(){
        selectBoundaries.setTitleColor(.systemBlue, for: .normal)
        selectBoundaries.backgroundColor = nil
        selectBoundaries.layer.cornerRadius = 0
        selectBoundaries.clipsToBounds = false
        selectBoundaries.setTitle("Select Boundaries", for: .normal)
    }
    
    func extraSelected(){
        selectExtras.setTitleColor(.white, for: .normal)
        selectExtras.backgroundColor = .systemBlue
        selectExtras.layer.cornerRadius = 10
        selectExtras.clipsToBounds = true
    }
    
    func extraDiselected(){
        selectExtras.setTitleColor(.systemBlue, for: .normal)
        selectExtras.backgroundColor = nil
        selectExtras.layer.cornerRadius = 0
        selectExtras.clipsToBounds = false
        selectExtras.setTitle("Select Extras", for: .normal)
    }
    
    func initializeStepper(){
        stepper.value = 0
        runsTextField.text = String(Int(stepper.value))
    }
}
