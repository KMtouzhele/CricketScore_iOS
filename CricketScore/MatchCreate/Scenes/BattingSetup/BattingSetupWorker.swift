//
//  BattingSetupWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class BattingSetupWorker : BattingTeamSetupToFirestore {
    let db = Firestore.firestore()

    func addTeamAndPlayersToFirestore(response: BattingSetupModel.Response, completion: @escaping (String?) -> Void){
        addTeamToFirestore(response: response) { teamDocId in
            if let teamDocId = teamDocId {
                self.addPlayersToFirestore(response: response, teamDocID: teamDocId)
                completion(teamDocId)
            } else {
                print("Failed to add team to Firestore.")
                completion(nil)
            }
        }
    }

    func addTeamToFirestore(response: BattingSetupModel.Response, completion: @escaping (String?) -> Void) {
        let team = response.team
        let teamsCollection = db.collection("teams")
        var teamDoc: DocumentReference?
        do {
            teamDoc = try teamsCollection.addDocument(from: team) { (err) in
                if let err = err {
                    print("Error adding team document: \(err)")
                    completion(nil)
                } else {
                    print("Successfully created team.")
                    completion(teamDoc?.documentID)
                }
            }
        } catch let error {
            print("Error writing player to Firestore: \(error)")
            completion(nil)
        }
    }

    
    func addPlayersToFirestore(response: BattingSetupModel.Response, teamDocID: String) {
        let players = response.players
        let playersCollection = db.collection("players")
        
        for player in players {
            var playerData = player
            playerData.teamId = teamDocID
            do {
                try playersCollection.addDocument(from: playerData, completion: { (err) in
                    if let err = err {
                        print("Error adding player document: \(err)")
                    } else {
                        print("Successfully created player")
                    }
                })
            } catch let error {
                print("Error writing player to Firestore: \(error)")
            }
        }
        
    }
    
}
