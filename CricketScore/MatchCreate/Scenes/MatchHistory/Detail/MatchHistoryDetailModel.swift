//
//  MatchHistoryDetailModel.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation

struct MatchHistoryDetailModel {
    struct ViewModel {
        var matchDetailData: [
            (ballId: String,
            strikerName: String,
            nonStrikerName: String,
            bowlerName: String,
            result: ballType)
        ]
    }
}
