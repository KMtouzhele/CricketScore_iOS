//
//  ScoringInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/4.
//

import Foundation

protocol BallToFirestore {
    func addBallToFirestore(response: ScoringModel.Response.bassResponse)
}

protocol RetrievePlayersFromFirestore {
    func getPlayers(teamId: String) -> [String: String]
}

protocol PresentSocreBoard {
    func assembleScoreViewModel(request: ScoringModel.Request.scoreRequest, response: ScoringModel.Response.bassResponse)
    func assembleTeamPlayersViewModel(response: ScoringModel.Response.playersResponse)
    func presentDefaultBowlerSelection(ballRequest: ScoringModel.Request.ballRequest)
    func presentDefaultStrikerSelection(ballRequest: ScoringModel.Request.ballRequest)
    func presentSummaryViewModel(summaryViewModel: ScoringModel.ViewModel.summaryViewModel)
}

class ScoringInteractor : ScoringBusinessLogic {

    
    let worker = ScoringWorker()
    var presenter: PresentSocreBoard?
    init(presenter: ScoringPresenter){
        self.presenter = presenter
    }
    
    func getTeamPlayers(battingTeamId: String, bowlingTeamId: String, completion: @escaping () -> Void){
        DispatchQueue.global().async {
            let battingTeamDictionary = self.worker.getPlayers(teamId: battingTeamId)
            let bowlingTeamDictionary = self.worker.getPlayers(teamId: bowlingTeamId)
            let response = ScoringModel.Response.playersResponse(
                batterNames: battingTeamDictionary,
                bowlerNames: bowlingTeamDictionary
            )
            DispatchQueue.main.async {
                self.presenter?.assembleTeamPlayersViewModel(response: response)
                completion()
            }
        }
    }
    
    func addBall(
        ballRequest: ScoringModel.Request.ballRequest,
        scoreRequest: ScoringModel.Request.scoreRequest
    ) {
        var newRuns: Int
        switch ballRequest.result{
        case.fourBoundary:
            newRuns = 4
        case .sixBoundary:
            newRuns = 6
        default: newRuns = ballRequest.runs
        }
        
        let response = ScoringModel.Response.bassResponse(
            ball: Ball(
                matchId: ballRequest.matchId,
                striker: ballRequest.strikerId,
                nonStriker: ballRequest.nonStrikerId,
                bowler: ballRequest.bowlerId,
                runs: newRuns,
                isBallDelivered: isBallDelivered(request: ballRequest),
                result: ballRequest.result
            )
        )
        worker.addBallToFirestore(response: response)
        presenter?.assembleScoreViewModel(request: scoreRequest, response: response)
        updatePlayerStatus(ballRequest: ballRequest, scoreRequest: scoreRequest)
    }
    
    func updatePlayerStatus(
        ballRequest: ScoringModel.Request.ballRequest,
        scoreRequest: ScoringModel.Request.scoreRequest
    ) {
        let strikerId = ballRequest.strikerId
        let nonStrikerId = ballRequest.nonStrikerId
        let bowlerId = ballRequest.bowlerId
        if (ballRequest.result == .bowled ||
            ballRequest.result == .caught ||
            ballRequest.result == .caughtBowled ||
            ballRequest.result == .hitWicket ||
            ballRequest.result == .lbw ||
            ballRequest.result == .runOut ||
            ballRequest.result == .stumping
        ) {
            worker.updatePlayerStatusToFirestore(playerId: strikerId, playerStatus: .dismissed)
            presenter?.presentDefaultStrikerSelection(ballRequest: ballRequest)
        } else {
            worker.updatePlayerStatusToFirestore(playerId: strikerId, playerStatus: .playing)
        }
        
        //When hit 5 balls, then check the 6th balls result.
        if scoreRequest.overCalculator == 5 && (ballRequest.result != .noBall || ballRequest.result != .wide){
            worker.updatePlayerStatusToFirestore(playerId: nonStrikerId, playerStatus: .dismissed)
            presenter?.presentDefaultBowlerSelection(ballRequest: ballRequest)
        } else {
            worker.updatePlayerStatusToFirestore(playerId: nonStrikerId, playerStatus: .playing)
        }
        
        worker.updatePlayerStatusToFirestore(playerId: bowlerId, playerStatus: .playing)
    }
    
    func updateSummaryData(
        summaryViewModel: ScoringModel.ViewModel.summaryViewModel,
        ballRequest: ScoringModel.Request.ballRequest
    ){
        let strikerName = isWicket(request: ballRequest) ? "To be Selected" : summaryViewModel.strikerName
        let nonStrikerName = summaryViewModel.nonStrikerName
        let bowlerName = summaryViewModel.bowlerName
        let totalWickets = summaryViewModel.totalWickets
        let totalRuns = summaryViewModel.totalRuns
        let totalExtras = summaryViewModel.totalExtras
        let currentBall = summaryViewModel.currentBall
        let currentOver = summaryViewModel.currentOver
        
        let runs = ballRequest.runs
        let wicket = isWicket(request: ballRequest) ? 1 : 0
        let extra = isExtra(request: ballRequest) ? 1 : 0
        let teamRuns = isExtra(request: ballRequest) ? 1 : 0
        let boundaryRuns = getBoundaryRuns(request: ballRequest)
        
        var newCurrentBall: Int = 0
        var newCurrentOver: Int = 0
        var newBowlerName: String = "To be Selected"
        
        if !(currentBall == 5 &&
             isBallDelivered(request: ballRequest)
            ) {
            newCurrentBall = currentBall + 1
            newCurrentOver = currentOver
            newBowlerName = bowlerName
            if isExtra(request: ballRequest) {
                newCurrentOver = currentOver
                newCurrentBall = currentBall
                newBowlerName = bowlerName
            }
        } else {
            newCurrentOver = currentOver + 1
        }
        
        
        let updatedSummaryViewModel = ScoringModel.ViewModel.summaryViewModel(
            matchId: summaryViewModel.matchId,
            battingTeamId: summaryViewModel.battingTeamId,
            bowlingTeamId: summaryViewModel.bowlingTeamId,
            battingTeamName: "Placeholder",
            bowlingTeamName: "Placeholder",
            strikerName: strikerName,
            nonStrikerName: nonStrikerName,
            bowlerName: newBowlerName,
            totalWickets: totalWickets + wicket,
            totalRuns: totalRuns + runs + teamRuns + boundaryRuns,
            currentOver: newCurrentOver,
            currentBall: newCurrentBall,
            totalExtras: totalExtras + extra
        )
        presenter?.presentSummaryViewModel(summaryViewModel: updatedSummaryViewModel)
    }
    
    private func isBallDelivered(request: ScoringModel.Request.ballRequest) -> Bool {
        if request.result == ballType.noBall || request.result == ballType.wide {
            return false
        } else {
            return true
        }
    }
    
    private func isWicket(request: ScoringModel.Request.ballRequest) -> Bool {
        switch request.result {
        case.bowled,.caught,.caughtBowled,.hitWicket,.lbw,.runOut,.stumping:
            return true
        default:
            return false
        }
    }
    
    private func isExtra(request: ScoringModel.Request.ballRequest) -> Bool {
        switch request.result {
        case .noBall,.wide:
            return true
        default:
            return false
        }
    }
    
    private func getBoundaryRuns(request: ScoringModel.Request.ballRequest) -> Int {
        switch request.result {
        case .sixBoundary:
            return 6
        case .fourBoundary:
            return 4
        default: return 0
        }
    }
}
