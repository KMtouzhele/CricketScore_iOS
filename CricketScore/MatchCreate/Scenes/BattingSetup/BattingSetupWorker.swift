//
//  BattingSetupWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class BattingSetupWorker : TeamSetupToFirestore {
    let db = Firestore.firestore()

    func addTeamAndPlayersToFirestore(response: SetupList.Response){
        addTeamToFirestore(response: response) { teamDocId in
            if let teamDocId = teamDocId {
                self.addPlayersToFirestore(response: response, teamDocID: teamDocId)
            } else {
                print("Failed to add team to Firestore.")
            }
        }
    }

    func addTeamToFirestore(response: SetupList.Response, completion: @escaping (String?) -> Void) {
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

    
    func addPlayersToFirestore(response: SetupList.Response, teamDocID: String) {
        let team = response.team
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
