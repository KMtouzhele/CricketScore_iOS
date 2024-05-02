//
//  BowlingSetupInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation
import UIKit

protocol BowlingSetupToFirestore: AnyObject {
    func addMatchToFirebase(response: BowlingSetupModel.Response)
    func addTeamAndPlayersToFirestore(response: BattingSetupModel.Response)
}

protocol PresentBowlingSetupMessage: AnyObject {
    func dealWithEmptyResult(emptyResult: Bool)
}

class BowlingSetupInteractor : BowlingSetupLogic {
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
            //Do something while Empty
        } else {
            //Do something while valid
        }
    }
    
    func assembleTeam(request: BowlingSetupModel.Request) -> BowlingSetupModel.Response {
        let player1 = Player(name: request.playerName1, position: 1, status: playerStatus.available)
        let player2 = Player(name: request.playerName2, position: 2, status: playerStatus.available)
        let player3 = Player(name: request.playerName3, position: 3, status: playerStatus.available)
        let player4 = Player(name: request.playerName4, position: 4, status: playerStatus.available)
        let player5 = Player(name: request.playerName5, position: 5, status: playerStatus.available)
        let players = [player1, player2, player3, player4, player5]
        let teamName = request.teamName
        let battingTeamId = request.battingTeamId
        let team = Team(name: teamName, type: teamType.bowlingTeam)
        let match = Match(id: nil, battingTeamId: battingTeamId, bowlingTeamId: nil)
        let response = BowlingSetupModel.Response(team: team, players: players, match: match)
        return response
    }
    
    
}
