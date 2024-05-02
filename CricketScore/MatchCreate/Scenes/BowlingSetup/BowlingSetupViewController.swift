//
//  BowlingSetupViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation
import UIKit

protocol BowlingSetupLogic: AnyObject {
    func emptyValidation(request: BattingSetupModel.Request)
    func assembleTeam(request: BowlingSetupModel.Request) -> BowlingSetupModel.Response
}

class BowlingSetupViewController: UIViewController {
    var battingTeamId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.text = battingTeamId
        
    }
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var playerName1: UITextField!
    @IBOutlet weak var playerName2: UITextField!
    @IBOutlet weak var playerName3: UITextField!
    @IBOutlet weak var playerName4: UITextField!
    @IBOutlet weak var playerName5: UITextField!
}
