//
//  TabBarController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/7.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    var summaryViewModel = ScoringModel.ViewModel.summaryViewModel(
        battingTeamId: "",
        bowlingTeamId: "",
        battingTeamName: "",
        bowlingTeamName: "",
        strikerName: "To be Selected",
        nonStrikerName: "To be Selected",
        bowlerName: "To be Selected",
        totalWickets: 0,
        totalRuns: 0,
        currentOver: 0,
        currentBall: 0,
        totalExtras: 0
    )
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
