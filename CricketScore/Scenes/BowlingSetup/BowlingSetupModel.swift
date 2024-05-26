//
//  BowlingSetupModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation

struct BowlingSetupModel {
    struct Request {
        let teamName, playerName1, playerName2, playerName3, playerName4, playerName5: String
        let battingTeamId: String
    }
    
    struct Response {
        let team: Team
        let players: [Player]
        let match: Match
    }
    
    struct ViewModel {
        struct emptyError{
            let errorMessage: String
        }
    }
}
