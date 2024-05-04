//
//  ScoringModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation

struct ScoringModel {
    struct Request {
        let battingTeamId, bowlingTeamId: String
        
    }
    
    struct Response {
        struct bassResponse {
            let ball: Ball
        }
        struct playersResponse {
            let batterNames: [String: String]
            let bowlerNames: [String: String]
        }
    }
    
    struct ViewModel {
        struct score {
            let runsStriker: String
            let ballsFacedStriker: String
            let foursStriker: String
            let sixsStriker: String
            let runsNonStriker: String
            let ballsNonFacedStriker: String
            let foursNonStriker: String
            let sixsNonStriker: String
            let wickets: String
            let runsLost: String
            let ballsDelivered: String
        }
        struct teamPlayers {
            let batterNames: [String: String]
            let bowlerNames: [String: String]
        }
        struct error {
            let errorMessage: String
        }
    }
}
