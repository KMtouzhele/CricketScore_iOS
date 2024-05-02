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
    func addTeamAndPlayersToFirestore(response: BowlingSetupModel.Response, completion: @escaping (String?) -> Void)

}

protocol PresentBowlingSetupMessage: AnyObject {
    func presentEmptyMessage()
}

class BowlingSetupInteractor : BowlingSetupLogic {
    
    let worker = BowlingSetupWorker()
    var bowlingTeamId: String?
    var bowlingTeam: Team?
    var bowlers: [Player]?
    var match: Match?
    
    var presenter: BowlingSetupPresenter
    
    init(presenter: BowlingSetupPresenter){
        self.presenter = presenter
    }
    
    func prepareToFirestore(request: BowlingSetupModel.Request){
        print("prepareToFirestore Function is called")
        let isEmpty = emptyValidation(request: request)
        if isEmpty {
            self.presenter.presentEmptyMessage()
        } else {
            startAddingTeamToFirestore(request: request)
            startAddingMatchToFirestore(request: request)
        }
    }
    
    func startAddingTeamToFirestore(request: BowlingSetupModel.Request){
        let response = assembleTeam(request: request)
        worker.addTeamAndPlayersToFirestore(response: response) { teamDocId in
            if let teamDocId = teamDocId {
                self.bowlingTeamId = teamDocId
            } else {
                self.bowlingTeamId = nil
            }
        }
    }
    
    func startAddingMatchToFirestore(request: BowlingSetupModel.Request){
        let response = assembleMatch(request: request)
        worker.addMatchToFirebase(response: response)
        
    }
    
    func assembleTeam(request: BowlingSetupModel.Request) -> BowlingSetupModel.Response {
        let player1 = Player(name: request.playerName1, position: 1, status: playerStatus.available)
        let player2 = Player(name: request.playerName2, position: 2, status: playerStatus.available)
        let player3 = Player(name: request.playerName3, position: 3, status: playerStatus.available)
        let player4 = Player(name: request.playerName4, position: 4, status: playerStatus.available)
        let player5 = Player(name: request.playerName5, position: 5, status: playerStatus.available)
        self.bowlers = [player1, player2, player3, player4, player5]
        let teamName = request.teamName
        let battingTeamId = request.battingTeamId
        let team = Team(name: teamName, type: teamType.bowlingTeam)
        self.match = Match(battingTeamId: battingTeamId, bowlingTeamId: nil)
        let response = BowlingSetupModel.Response(team: team, players: self.bowlers!, match: self.match!)
        return response
    }
    
    func assembleMatch(request: BowlingSetupModel.Request) -> BowlingSetupModel.Response {
        self.match = Match(battingTeamId: request.battingTeamId, bowlingTeamId: self.bowlingTeamId)
        let response = BowlingSetupModel.Response(team: self.bowlingTeam!, players: self.bowlers!, match: self.match!)
        return response
    }
    
    func emptyValidation(request: BowlingSetupModel.Request) -> Bool {
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
            return true
        } else {
            return false
        }
    }
    
    
}
