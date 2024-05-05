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
    func swapBattersScore(request: ScoringModel.Request.scoreRequest)
    func assembleTeamPlayersViewModel(response: ScoringModel.Response.playersResponse)
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
                striker: ballRequest.striker,
                nonStriker: ballRequest.nonStriker,
                bowler: ballRequest.bowler,
                runs: ballRequest.runs,
                isBallDelivered: isBallDelivered(request: ballRequest),
                result: ballRequest.result
            )
        )
        worker.addBallToFirestore(response: response)
        presenter?.assembleScoreViewModel(request: scoreRequest, response: response)
        
//        if ballRequest.runs % 2 == 1 {
//            presenter?.swapBattersScore(request: scoreRequest)
//        }
    }
    
    func isBallDelivered(request: ScoringModel.Request.ballRequest) -> Bool {
        if request.result == ballType.noBall || request.result == ballType.wide {
            return false
        } else {
            return true
        }
    }
    
}
