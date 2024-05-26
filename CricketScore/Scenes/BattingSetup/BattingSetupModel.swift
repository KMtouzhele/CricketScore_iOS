//
//  BattingSetupModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation

struct BattingSetupModel {
    struct Request {
        let teamName, playerName1, playerName2, playerName3, playerName4, playerName5: String
    }
    
    struct Response {
        let team: Team
        let players: [Player]
    }
    
    struct ViewModel {
        struct emptyError{
            let errorMessage: String
        }
    }
}
