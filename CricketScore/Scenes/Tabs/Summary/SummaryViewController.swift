//
//  SummaryViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/6.
//

import Foundation
import UIKit

protocol SummaryViewBusinessLogic: AnyObject {
    func getTeamName(request: SummaryModel.Request)
}

class SummaryViewController: UIViewController, DisplaySummary {
    
    var interactor: SummaryViewBusinessLogic?
    var presenter = SummaryPresenter()
    var battingTeamName = ""
    var bowlingTeamName = ""
    
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
        self.interactor = SummaryInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        
        if let tabBar = self.tabBarController as? TabBarController {
            let viewModel = tabBar.summaryViewModel
            
            let battingTeamId = viewModel.battingTeamId
            let bowlingTeamId = viewModel.bowlingTeamId
            
            let request = SummaryModel.Request(
                battingteamId: battingTeamId,
                bowlingteamId: bowlingTeamId
            )
            displaySummary(viewModel: viewModel)
            self.interactor?.getTeamName(request: request)
            
        } else {
            print("Unable to access TabBarController")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let tabBar = self.tabBarController as? TabBarController {
            let viewModel = tabBar.summaryViewModel
            displaySummary(viewModel: viewModel)
            let teamNameVM = SummaryModel.ViewModel.teamNames(
                battingTeamName: self.battingTeamName,
                bowlingTeamName: self.bowlingTeamName
            )
            displayTeamNames(viewModel: teamNameVM)
        } else {
            print("Unable to access TabBarController")
        }
    }
    
    func displaySummary(viewModel: ScoringModel.ViewModel.summaryViewModel){
        let totalBalls = viewModel.currentOver * 6 + viewModel.currentBall
        var runRate: Float
        if totalBalls == 0 {
            runRate = 0
        } else {
            runRate = Float(viewModel.totalRuns) / (Float(totalBalls) / 6)
        }
        battingScoreLabel.text = "\(viewModel.totalWickets) / \(viewModel.totalRuns)"
        runRateLabel.text = String(format: "%.3f", runRate)
        currentOverLabel.text = "\(viewModel.currentOver) . \(viewModel.currentBall)"
        extrasLabel.text = "\(viewModel.totalExtras)"
        battingTeamNameLabel.text = viewModel.battingTeamName
        bowlingTeamNameLabel.text = viewModel.bowlingTeamName
        strikerNameLabel.text = viewModel.strikerName
        nonStrikerNameLabel.text = viewModel.nonStrikerName
        bowlerNameLabel.text = viewModel.bowlerName
    }
    
    func displayTeamNames(viewModel: SummaryModel.ViewModel.teamNames) {
        battingTeamNameLabel.text = viewModel.battingTeamName
        bowlingTeamNameLabel.text = viewModel.bowlingTeamName
    }
    
}
