//
//  SummaryModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/7.
//

import Foundation

struct SummaryModel {
    struct Request {
        let battingteamId: String
        let bowlingteamId: String
    }
    
    struct Response {
        let battingTeamName: String
        let bowlingTeamName: String
    }
    
    struct ViewModel {
        struct teamNames {
            let battingTeamName: String
            let bowlingTeamName: String
        }
    }
}
