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
        let runsStriker = request.runsStriker
        let ballsFacedStriker = request.ballsFacedStriker
        let fourBoundaryStriker = request.foursStriker
        let sixBoundaryStriker = request.sixsStriker
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
        
        let viewModel = ScoringModel.ViewModel.score(
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
    }
    
    func assembleTeamPlayersViewModel(response: ScoringModel.Response.playersResponse) {
        let battersDictionary = response.batterNames
        let bowlersDictionary = response.bowlerNames
        viewController?.battingTeamDic = battersDictionary
        viewController?.bowlingTeamDic = bowlersDictionary
    }
    
    func swapBattersScore(request: ScoringModel.Request.scoreRequest) {
        var runsStriker = request.runsStriker
        var ballsFacedStriker = request.ballsFacedStriker
        var foursStriker = request.foursStriker
        var sixsStriker = request.sixsStriker
        var runsNonStriker = request.runsNonStriker
        var ballsFacedNonStriker = request.ballsFacedNonStriker
        var foursNonStriker = request.foursNonStriker
        var sixsNonStriker = request.sixsNonStriker
        
        var temp = runsStriker
        runsStriker = runsNonStriker
        runsNonStriker = temp
        
        temp = ballsFacedStriker
        ballsFacedStriker = ballsFacedNonStriker
        
        temp = foursStriker
        foursStriker = foursNonStriker
        foursNonStriker = temp
        
        temp = sixsStriker
        sixsStriker = sixsNonStriker
        sixsNonStriker = temp
        
        let swappedViewModel = ScoringModel.ViewModel.score(
            runsStriker: runsStriker,
            ballsFacedStriker: ballsFacedStriker,
            foursStriker: foursStriker,
            sixsStriker: sixsStriker,
            runsNonStriker: runsNonStriker,
            ballsFacedNonStriker: ballsFacedNonStriker,
            foursNonStriker: foursNonStriker,
            sixsNonStriker: sixsNonStriker,
            wickets: request.wickets,
            runsLost: request.runsLost,
            ballsDelivered: request.ballsDelivered)
        viewController?.displayScoreBoard(viewModel: swappedViewModel)
    }
    
}
