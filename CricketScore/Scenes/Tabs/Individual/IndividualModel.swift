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
            let strikerNamesDic: [String: String]
            let strikerRunsDic: [String: Int]
            let strikerBallsFacedDic: [String: Int]
        }
        
        struct BowlerResponse {
            let bowlerNamesDic: [String: String]
            let bowlerRunsLostDic: [String: Int]
            let bowlerBallsDeliveredDic: [String: Int]
            let bowlerWicketsDic: [String: Int]
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
    
    struct tableData {
        var strikers : [(striker: String, name: String, runs: Int, ballsFaced: Int)]
        var bowlers: [(bowler: String, name: String, runsLost: Int, ballsDelivered: Int, wickets: Int)]
    }
}
