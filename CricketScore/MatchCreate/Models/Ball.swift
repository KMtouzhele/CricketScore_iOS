//
//  Ball.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/3.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Ball: Codable {
    let matchId: String
    let striker: String
    let nonStriker: String
    let bowler: String
    let runs: Int
    let isBallDelivered: Bool
    let result: ballType
}

enum ballType: String, Codable {
    case runs
    case boundaries
    case bowled
    case caught
    case caughtBowled
    case lbw
    case hitWicket
    case runOut
    case stumping
    case emptyWicket
    case noBall
    case wide
    case emptyExtra
}
