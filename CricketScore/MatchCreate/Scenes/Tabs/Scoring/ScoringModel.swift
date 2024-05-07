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
            let strikerId, nonStrikerId, bowlerId: String
            let runs: Int
            let result: ballType
        }
        struct scoreRequest {
            let overCalculator: Int
            let strikerId: String
            let nonStrikerId: String
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
        struct summaryRequest {
            var totalWickets: Int
            var totalRuns: Int
            var currentOver: Int
            var currentBall: Int
            var totalExtras: Int
            var strikerId: String
            var nonStrikerId: String
            var bowlerId: String
            var strikerName: String
            var nonStrikerName: String
            var bowlerName: String
            var battingTeamId: String
            var bowlingTeamId: String
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
        struct summaryResponse {
            var totalWickets: Int
            var totalRuns: Int
            var currentOver: Int
            var currentBall: Int
            var totalExtras: Int
            var strikerName: String
            var nonStrikerName: String
            var bowlerName: String
            var battingTeamName: String
            var bowlingTeamName: String
        }
    }
    
    struct ViewModel {
        struct score {
            let overCalculator: Int
            let strikerId: String
            let nonStrikerId: String
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
        
        struct summaryViewModel {
            var battingTeamId: String
            var bowlingTeamId: String
            var battingTeamName: String
            var bowlingTeamName: String
            var strikerName: String
            var nonStrikerName: String
            var bowlerName: String
            var totalWickets: Int
            var totalRuns: Int
            var currentOver: Int
            var currentBall: Int
            var totalExtras: Int
        }
        struct error {
            let errorMessage: String
        }
    }
}
