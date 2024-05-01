//
//  Player.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Player : Codable {
    @DocumentID var documentID: String?
    var name: String
    var position: Int
    var status: playerStatus
    var teamId: String?
}

enum playerStatus: String, Codable {
    case available
    case playing
    case dismissed
}
