//
//  ScoringViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation
import UIKit

protocol ScoringBusinessLogic {
    func getTeamPlayers(battingTeamId: String, bowlingTeamId: String)
}

enum PickerType {
    case boundaries
    case wickets
    case extras
}

class ScoringViewController: UIViewController, UpdateScoreBoard {
    
    var battingTeamId: String?
    var bowlingTeamId: String?
    var matchId: String?
    
    var battingTeamDic: [String: String]?
    var bowlingTeamDic: [String: String]?
    var interactor: ScoringBusinessLogic?
    var presenter = ScoringPresenter()
    
    var striker: String?
    var nonStriket: String?
    var bowler: String?
    var runs: Int = 0
    var result: ballType?
    
    let boundaries = ["4s", "6s"]
    let wickets = ["Bowled", "Caught", "Caught&Bowled", "LBW", "Hit Wicket", "Run Out", "Stumping"]
    let extras = ["No Ball", "Wide"]
    
    var currentPickerType: PickerType = .boundaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = ScoringInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        interactor?.getTeamPlayers(battingTeamId: battingTeamId!, bowlingTeamId: bowlingTeamId!)
        initializeViewStatus()
    }
    
    func updatePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    func initializeViewStatus(){
        runsTextField.text = "0"
        pickerView.isHidden = true
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
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var runsTextField: UITextField!
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        
    }
    @IBAction func btnConfirm(_ sender: UIButton) {
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
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentPickerType {
        case .boundaries:
            selectBoundaries.setTitle(boundaries[row], for: .normal)
        case.wickets:
            selectWicket.setTitle(wickets[row], for: .normal)
        case.extras:
            selectExtras.setTitle(extras[row], for: .normal)
        }
        pickerView.isHidden = true
    }
    
}
