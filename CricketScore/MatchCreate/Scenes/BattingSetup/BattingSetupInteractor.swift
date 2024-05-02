//
//  BattingSetupInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation
import UIKit

protocol BattingTeamSetupToFirestore: AnyObject {
    func addTeamAndPlayersToFirestore(response: BattingSetupModel.Response, completion: @escaping (String?) -> Void)
}

protocol PresentBattingSetupMessage: AnyObject {
    func dealWithEmptyResult(emptyResult: Bool, teamId: String)
}

class BattingSetupInteractor : BattingSetupLogic {
    let worker = BattingSetupWorker()
    var presenter: BattingSetupPresenter
    
    init(presenter: BattingSetupPresenter){
        self.presenter = presenter
    }
    
    func assembleTeam(request: BattingSetupModel.Request) -> BattingSetupModel.Response {
        let player1 = Player(name: request.playerName1, position: 1, status: playerStatus.available)
        let player2 = Player(name: request.playerName2, position: 2, status: playerStatus.available)
        let player3 = Player(name: request.playerName3, position: 3, status: playerStatus.available)
        let player4 = Player(name: request.playerName4, position: 4, status: playerStatus.available)
        let player5 = Player(name: request.playerName5, position: 5, status: playerStatus.available)
        let players = [player1, player2, player3, player4, player5]
        let teamName = request.teamName
        let team = Team(name: teamName, type: teamType.battingTeam)
        let response = BattingSetupModel.Response(team: team, players: players)
        return response
    }
    
    func emptyValidation(request: BattingSetupModel.Request) {
        let teamName = request.teamName
        let playerName1 = request.playerName1
        let playerName2 = request.playerName2
        let playerName3 = request.playerName3
        let playerName4 = request.playerName4
        let playerName5 = request.playerName5
        if (
            teamName.isEmpty ||
            playerName1.isEmpty ||
            playerName2.isEmpty ||
            playerName3.isEmpty ||
            playerName4.isEmpty ||
            playerName5.isEmpty
        ) {
            self.presenter.dealWithEmptyResult(emptyResult: true, teamId: "")
            print("BattingSetupInteractor: Some textfields are empty.")
        } else {
            print("BattingSetupInteractor: Valid input. Assembling batting team info.")
            let response = assembleTeam(request: request)
            worker.addTeamAndPlayersToFirestore(response: response) { teamId in
                if let teamId = teamId {
                    print("BattingSetupInteractor: BattingTeamId: \(teamId)")
                    self.presenter.dealWithEmptyResult(emptyResult: false, teamId: teamId)
                } else {
                    print("BattingSetupInteractor: BattingTeamId is nil")
                }
            }
        }
    }
    
    
}
