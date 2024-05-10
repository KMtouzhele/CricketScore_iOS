//
//  SettingsModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/9.
//

import Foundation

struct SettingsModel {
    struct Request {
        let matchId: String
    }
    
    struct Response {
        
    }
    
    struct ViewModel {
        var players: [(playerId: String, name: String, status: playerStatus, teamType: teamType)]
    }
}
