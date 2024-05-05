//
//  ScoringWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/4.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ScoringWorker: RetrievePlayersFromFirestore, BallToFirestore {
    func getPlayers(teamId: String) -> [String: String] {
        var players = [String: String]()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getPlayersByTeamId(teamId: teamId) { (result, error) in
            if let result = result {
                players = result
            }
            dispatchGroup.leave()
        }
        dispatchGroup.wait()
        return players
    }
    
    func addBallToFirestore(response: ScoringModel.Response.bassResponse) {
        let ball = response.ball
        let db = Firestore.firestore()
        let ballsCollection = db.collection("balls")
        do {
            try ballsCollection.addDocument(from: ball) { (err) in
                if let err = err {
                    print("Error adding ball document: \(err)")
                } else {
                    print("Successfully created ball.")
                }
            }
        } catch let error {
            print("Error writing ball to Firestore: \(error)")
        }
    }
    
    func getPlayersByTeamId(teamId: String, completion: @escaping([String : String]?, Error?) -> Void) {
        var playersDictionary = [String: String]()
        
        let db = Firestore.firestore()
        let playersCollection = db.collection("players")
        
        let query = playersCollection.whereField("teamId", isEqualTo: teamId)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let documents = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            for doc in documents {
                let docId = doc.documentID
                let playerName = doc.data()["name"] as? String ?? ""
                playersDictionary[docId] = playerName
            }
            completion(playersDictionary, nil)
        }
    }
    
    func updatePlayerStatusToFirestore(playerId: String, playerStatus: playerStatus) {
        let db = Firestore.firestore()
        let playerDoc = db.collection("players").document(playerId)
        
        let statusString : String
        switch playerStatus {
        case .available:
            statusString = "available"
        case.dismissed:
            statusString = "dismissed"
        case .playing:
            statusString = "playing"
        }
        let newStatus = ["status" : statusString ]
        
        playerDoc.updateData(newStatus) { error in
            if let error = error {
                print("Error updating player document \(error)")
            } else {
                print("Successfully updated player to \(playerStatus)")
            }
        }
    }
}
