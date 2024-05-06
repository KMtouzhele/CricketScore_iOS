//
//  SummaryViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/6.
//

import Foundation
import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var battingScoreLabel: UILabel!
    @IBOutlet weak var runRateLabel: UILabel!
    @IBOutlet weak var currentOverLabel: UILabel!
    @IBOutlet weak var extrasLabel: UILabel!
    @IBOutlet weak var battingTeamNameLabel: UILabel!
    @IBOutlet weak var bowlingTeamNameLabel: UILabel!
    @IBOutlet weak var strikerNameLabel: UILabel!
    @IBOutlet weak var bowlerNameLabel: UILabel!
    @IBOutlet weak var nonStrikerNameLabel: UILabel!
    
    var totalWickets: Int = 0
    var totalRuns: Int = 0
    var currentOver: Int = 0
    var currentBall: Int = 0
    var totalExtras: Int = 0
}
