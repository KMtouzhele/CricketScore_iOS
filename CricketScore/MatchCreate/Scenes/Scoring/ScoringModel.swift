//
//  ScoringModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation

struct ScoringModel {
    struct Request {
        struct ballRequest{
            let matchId, battingTeamId, bowlingTeamId: String
            let striker, nonStriker, bowler: String
            let runs: Int
            let result: ballType
        }
        struct scoreRequest {
            let runsStriker: Int
            let ballsFacedStriker: Int
            let foursStriker: Int
            let sixsStriker: Int
            let runsNonStriker: Int
            let ballsFacedNonStriker: Int
            let foursNonStriker: Int
            let sixsNonStriker: Int
            let wickets: Int
            let runsLost: Int
            let ballsDelivered: Int
        }
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
            let runsStriker: Int
            let ballsFacedStriker: Int
            let foursStriker: Int
            let sixsStriker: Int
            let runsNonStriker: Int
            let ballsFacedNonStriker: Int
            let foursNonStriker: Int
            let sixsNonStriker: Int
            let wickets: Int
            let runsLost: Int
            let ballsDelivered: Int
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
