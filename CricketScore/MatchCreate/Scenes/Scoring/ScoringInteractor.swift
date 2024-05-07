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
    func assembleSummaryViewModel(response: ScoringModel.Response.summaryResponse)
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
        let response = ScoringModel.Response.bassResponse(
            ball: Ball(
                matchId: ballRequest.matchId,
                striker: ballRequest.strikerId,
                nonStriker: ballRequest.nonStrikerId,
                bowler: ballRequest.bowlerId,
                runs: ballRequest.runs,
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
        summaryRequest: ScoringModel.Request.summaryRequest,
        ballRequest: ScoringModel.Request.ballRequest
    ){
        let strikerId = summaryRequest.strikerId
        let nonStrikerId = summaryRequest.nonStrikerId
        let bowlerId = summaryRequest.bowlerId
        let totalWickets = summaryRequest.totalWickets
        let totalRuns = summaryRequest.totalRuns
        let totalExtras = summaryRequest.totalExtras
        let currentBall = summaryRequest.currentBall
        let currentOver = summaryRequest.currentOver
        
        let runs = ballRequest.runs
        let ballDelivered = isBallDelivered(request: ballRequest) ? 1 : 0
        let wicket = isWicket(request: ballRequest) ? 1 : 0
        let extra = isExtra(request: ballRequest) ? 1 : 0
        let teamRuns = isExtra(request: ballRequest) ? 1 : 0
        let boundaryRuns = getBoundaryRuns(request: ballRequest)
        
        var newCurrentBall: Int = 0
        var newCurrentOver: Int = 0
        if !(currentBall == 5 &&
             isBallDelivered(request: ballRequest)
            ) {
            newCurrentBall = currentBall + 1
            newCurrentOver = currentOver
            if isExtra(request: ballRequest) {
                newCurrentOver = currentOver
                newCurrentBall = currentBall
            }
        } else {
            newCurrentOver = currentOver + 1
        }
        
        let response = ScoringModel.Response.summaryResponse(
            totalWickets: totalWickets + wicket,
            totalRuns: totalRuns + runs + teamRuns + boundaryRuns,
            currentOver: newCurrentOver,
            currentBall: newCurrentBall,
            totalExtras: totalExtras + extra,
            strikerName: "PlaceHolder",
            nonStrikerName: "PlaceHolder",
            bowlerName: "PlaceHolder",
            battingTeamName: "PlaceHolder",
            bowlingTeamName: "PlaceHolder"
        )
        print("Update summary interactor: old wicket is \(totalWickets) and adding \(wicket)")
        presenter?.assembleSummaryViewModel(response: response)
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
