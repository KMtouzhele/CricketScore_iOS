//
//  ScoringViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation
import UIKit

class ScoringViewController: UIViewController {
    var battingTeamId: String?
    var bowlingTeamId: String?
    var matchId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        battingTxt.text = battingTeamId
        bowlingTxt.text = bowlingTeamId
        matchTxt.text = matchId
    }


    @IBOutlet weak var battingTxt: UILabel!
    @IBOutlet weak var bowlingTxt: UILabel!
    @IBOutlet weak var matchTxt: UILabel!
}
