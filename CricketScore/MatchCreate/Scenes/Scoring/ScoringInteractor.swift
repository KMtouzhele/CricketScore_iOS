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
    //func assembleScoreViewModel(response: ScoringModel.Response.bassResponse) -> ScoringModel.ViewModel.score
    func assembleTeamPlayersViewModel(response: ScoringModel.Response.playersResponse)
}

class ScoringInteractor : ScoringBusinessLogic {
    let worker = ScoringWorker()
    var presenter: PresentSocreBoard?
    init(presenter: ScoringPresenter){
        self.presenter = presenter
    }
    
    func getTeamPlayers(battingTeamId: String, bowlingTeamId: String){
        let battingTeamDictionary = worker.getPlayers(teamId: battingTeamId)
        let bowlingTeamDictionary = worker.getPlayers(teamId: bowlingTeamId)
        let response = ScoringModel.Response.playersResponse(batterNames: battingTeamDictionary, bowlerNames: bowlingTeamDictionary)
        presenter?.assembleTeamPlayersViewModel(response: response)
    }
}
