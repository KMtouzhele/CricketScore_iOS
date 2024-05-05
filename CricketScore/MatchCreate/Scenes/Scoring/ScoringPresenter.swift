//
//  ScoringPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/4.
//

import Foundation

protocol UpdateScoreBoard {
    func displayScoreBoard(viewModel: ScoringModel.ViewModel.score)
}

class ScoringPresenter: PresentSocreBoard {
    
    weak var viewController: ScoringViewController?
    
    func assembleScoreViewModel(
        request: ScoringModel.Request.scoreRequest,
        response: ScoringModel.Response.bassResponse
    ) {
        let overCalculator = request.overCalculator
        let strikerId = request.strikerId
        let nonStrikerId = request.nonStrikerId
        let runsStriker = request.runsStriker
        let ballsFacedStriker = request.ballsFacedStriker
        let fourBoundaryStriker = request.foursStriker
        let sixBoundaryStriker = request.sixsStriker
        
        let runsNonStriker = request.runsNonStriker
        let ballsFacedNonStriker = request.ballsFacedNonStriker
        let fourBoundaryNonStriker = request.ballsFacedNonStriker
        let sixBoundaryNonStriker = request.sixsNonStriker
        
        let runsLost = request.runsLost
        let ballsDelivered = request.ballsDelivered
        let totalWickets = request.wickets
        
        let result = response.ball.result
        var runs = response.ball.runs
        var teamRuns = 0
        var isDelivered: Int = 1
        var fourBoundary: Int = 0
        var sixBoundary: Int = 0
        var wicket: Int = 0
        
        switch result {
        case .fourBoundary: fourBoundary = 1; runs = 4
        case .sixBoundary: sixBoundary = 1; runs = 6
        case .bowled, .caught, .caughtBowled, .hitWicket, .lbw, .runOut, .stumping: wicket = 1
        case .runs: runs = response.ball.runs
        case .noBall: isDelivered = 0; teamRuns = 1
        case .wide: isDelivered = 0; teamRuns = 1
        case .empty: runs = 0
        }
        
        if response.ball.runs % 2 == 0 {
            let viewModel = ScoringModel.ViewModel.score(
                overCalculator: overCalculator + isDelivered,
                strikerId: strikerId,
                nonStrikerId: nonStrikerId,
                runsStriker: runsStriker + runs,
                ballsFacedStriker: ballsFacedStriker + isDelivered,
                foursStriker: fourBoundaryStriker + fourBoundary,
                sixsStriker: sixBoundaryStriker + sixBoundary,
                runsNonStriker: request.runsNonStriker,
                ballsFacedNonStriker: request.ballsFacedNonStriker,
                foursNonStriker: request.foursNonStriker,
                sixsNonStriker: request.sixsNonStriker,
                wickets: totalWickets + wicket,
                runsLost: runsLost + runs + teamRuns,
                ballsDelivered: ballsDelivered + isDelivered
            )
            print("Origin runs is \(runsStriker)")
            print("New added run is \(runs)")
            viewController?.displayScoreBoard(viewModel: viewModel)
        } else {
            let viewModel = ScoringModel.ViewModel.score(
                overCalculator: overCalculator + isDelivered,
                strikerId: nonStrikerId,
                nonStrikerId: strikerId,
                runsStriker: runsNonStriker,
                ballsFacedStriker: ballsFacedNonStriker,
                foursStriker: fourBoundaryNonStriker,
                sixsStriker: sixBoundaryNonStriker,
                runsNonStriker: runsStriker + runs,
                ballsFacedNonStriker: ballsFacedStriker + isDelivered,
                foursNonStriker: fourBoundaryStriker + fourBoundary,
                sixsNonStriker: sixBoundaryStriker + sixBoundary,
                wickets: totalWickets + wicket,
                runsLost: runsLost + runs + teamRuns,
                ballsDelivered: ballsDelivered + isDelivered
            )
            viewController?.displayScoreBoard(viewModel: viewModel)
        }
    }

    func assembleTeamPlayersViewModel(response: ScoringModel.Response.playersResponse) {
        let battersDictionary = response.batterNames
        let bowlersDictionary = response.bowlerNames
        viewController?.battingTeamDic = battersDictionary
        viewController?.bowlingTeamDic = bowlersDictionary
    }
    
}
