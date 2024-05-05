//
//  ScoringViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation
import UIKit

protocol ScoringBusinessLogic {
    func getTeamPlayers(battingTeamId: String, bowlingTeamId: String, completion: @escaping () -> Void)
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
    
    var battingTeamId: String?
    var bowlingTeamId: String?
    var matchId: String?
    
    var battingTeamDic: [String: String]?
    var bowlingTeamDic: [String: String]?
    var battingNamesArray: [String]?
    var bowlingNamesArray: [String]?
    
    var interactor: ScoringBusinessLogic?
    var presenter = ScoringPresenter()
    
    var striker: String?
    var nonStriker: String?
    var bowler: String?
    var runs: Int?
    var result: ballType = .runs
    
    let boundaries = ["4s", "6s"]
    let wickets = ["Bowled", "Caught", "Caught&Bowled", "LBW", "Hit Wicket", "Run Out", "Stumping"]
    let extras = ["No Ball", "Wide"]
    
    var currentPickerType: PickerType = .boundaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnConfirm.isEnabled = false
        self.interactor = ScoringInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        self.interactor?.getTeamPlayers(battingTeamId: self.battingTeamId!, bowlingTeamId: self.bowlingTeamId!) { [weak self] in
            self?.initializeViewStatus()
            
            guard let battingTeamDic = self?.battingTeamDic else {
                print("BattingTeamDic is nil")
                return
            }
            self?.battingNamesArray = Array(battingTeamDic.values)
            
            guard let bowlingTeamDic = self?.bowlingTeamDic else {
                print("BowlingTeamDic is nil")
                return
            }
            self?.bowlingNamesArray = Array(bowlingTeamDic.values)
            
            self?.enableButtons()
            
        }
    }
    
    func updatePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    func initializeViewStatus(){
        selectStriker.setTitle("Striker", for: .normal)
        runsTextField.text = "0"
        pickerView.isHidden = true
    }
    
    func enableButtons(){
        selectStriker.isEnabled = true
        selectNonStriker.isEnabled = true
        selectBowler.isEnabled = true
    }
    
    func displayScoreBoard(viewModel: ScoringModel.ViewModel.score) {
        runsStriker.text = viewModel.runsStriker
        ballsFacedStriker.text = viewModel.ballsFacedStriker
        fourStriker.text = viewModel.foursStriker
        sixStriker.text = viewModel.sixsStriker
        runsNonStriker.text = viewModel.runsNonStriker
        ballsFacedNonStriker.text = viewModel.ballsNonFacedStriker
        fourNonStriker.text = viewModel.foursNonStriker
        sixNonStriker.text = viewModel.sixsNonStriker
        totalWickets.text = viewModel.wickets
        runsLost.text = viewModel.runsLost
        ballsDelivered.text = viewModel.ballsDelivered
    }
    
    func updateBtnConfirmStatus(){
        if striker != nil && nonStriker != nil {
            btnConfirm.isEnabled = true
        } else {
            btnConfirm.isEnabled = false
        }
    }
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func btnConfirm(_ sender: UIButton) {
    }
    @IBAction func btnReset(_ sender: UIButton) {
        extraDiselected()
        boundaryDiselected()
        wicketDiselected()
        runsTextField.text = "0"
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
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        runsTextField.text = "\(sender.value)"
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
//https://www.youtube.com/watch?v=ykycTzKXON8
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
            self.result = ballType.boundaries
            boundarySelected()
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
            default: self.result = ballType.emptyWicket
            }
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
            default: self.result = ballType.emptyExtra
            }
            boundaryDiselected()
            wicketDiselected()
            updateBtnConfirmStatus()
            print("Ball result is \(String(describing: self.result))")
        
        case .striker:
            selectStriker.setTitle(battingNamesArray![row], for: .normal)
            if let selectedStrikerName = battingNamesArray?[row]{
                for (key, value) in battingTeamDic ?? [:] {
                    if value == selectedStrikerName {
                        self.striker = key
                        break
                    }
                }
            }
            updateBtnConfirmStatus()
            print("Selected Batter: \(String(describing: self.striker))")
            
        case .nonStriker:
            selectNonStriker.setTitle(battingNamesArray![row], for: .normal)
            if let selectedNonStrikerName = battingNamesArray?[row]{
                for (key, value) in battingTeamDic ?? [:] {
                    if value == selectedNonStrikerName {
                        self.nonStriker = key
                        break
                    }
                }
            }
            updateBtnConfirmStatus()
            print("Selected Batter: \(String(describing: self.nonStriker))")
        case .bowler:
            selectBowler.setTitle(bowlingNamesArray![row], for: .normal)
            if let selectedBowlerName = bowlingNamesArray?[row]{
                for (key, value) in bowlingTeamDic ?? [:] {
                    if value == selectedBowlerName {
                        self.bowler = key
                        break
                    }
                }
            }
            updateBtnConfirmStatus()
            print("Selected Bowler: \(String(describing: self.bowler))")
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
}
