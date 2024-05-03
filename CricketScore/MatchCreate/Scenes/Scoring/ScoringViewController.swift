//
//  ScoringViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation
import UIKit

enum PickerType {
    case boundaries
    case wickets
}

class ScoringViewController: UIViewController {
    var battingTeamId: String?
    var bowlingTeamId: String?
    var matchId: String?
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
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var runsTextField: UITextField!
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        
    }
    @IBAction func btnConfirm(_ sender: UIButton) {
    }
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
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch currentPickerType {
        case .boundaries:
            return boundaries[row]
        case .wickets:
            return wickets[row]
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentPickerType {
        case .boundaries:
            selectBoundaries.setTitle(boundaries[row], for: .normal)
        case.wickets:
            selectWicket.setTitle(wickets[row], for: .normal)
        }
        pickerView.isHidden = true
    }
    
}
