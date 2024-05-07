//
//  SummaryViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/6.
//

import Foundation
import UIKit

class SummaryViewController: UIViewController {
    
    var presenter = ScoringPresenter()
    
    @IBOutlet weak var battingScoreLabel: UILabel!
    @IBOutlet weak var runRateLabel: UILabel!
    @IBOutlet weak var currentOverLabel: UILabel!
    @IBOutlet weak var extrasLabel: UILabel!
    @IBOutlet weak var battingTeamNameLabel: UILabel!
    @IBOutlet weak var bowlingTeamNameLabel: UILabel!
    @IBOutlet weak var strikerNameLabel: UILabel!
    @IBOutlet weak var bowlerNameLabel: UILabel!
    @IBOutlet weak var nonStrikerNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.summaryViewController = self
    }
    
    func displaySummary(viewModel: ScoringModel.ViewModel.summaryViewModel){
        battingScoreLabel.text = viewModel.battingTeamScore
        runRateLabel.text = viewModel.RunRate
        currentOverLabel.text = viewModel.currentOver
        extrasLabel.text = viewModel.TotalExtras
        battingTeamNameLabel.text = viewModel.battingTeamName
        bowlingTeamNameLabel.text = viewModel.bowlingTeamName
        strikerNameLabel.text = viewModel.strikerName
        nonStrikerNameLabel.text = viewModel.nonStrikerName
        bowlerNameLabel.text = viewModel.bowlerName
    }
}
