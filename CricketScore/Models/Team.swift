//
//  Team.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation

struct Team : Codable {
    let name: String
    let type: teamType
}

enum teamType : String, Codable{
    case battingTeam
    case bowlingTeam
}
