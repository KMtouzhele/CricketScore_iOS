//
//  IndividualModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import Foundation

struct IndividualModel {
    struct Request {
        let battingTeamId: String
        let bowlingTeamId: String
    }
    
    struct Response {
        struct BatterResponse {
            let strikerRunsDic: [String: Int]
            let strikerBallsFacedDic: [String: Int]
        }
        
        struct BowlerResponse {
            let bowlerName: String
            let runsLost: Int
            let wickets: Int
            let ballsDelivered: Int
            
        }
    }
    
    struct ViewModel {
        struct BatterViewModel {
            let batterIndividual: [(striker: String, runs: Int, ballsFaced: Int)]
            
        }
        struct BowlerViewModel {
            let bowlerindividual: [(bowler: String, runs: Int, ballsFaced: Int)]
        }
    }
}
