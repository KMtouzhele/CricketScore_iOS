//
//  SettingsWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/9.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingsWorker {
    func getPlayers(matchId: String, completion: @escaping ([(String,String,playerStatus,teamType)]?) -> Void){
        getTeamId(matchId: matchId) { battingTeamId, bowlingTeamId in
            guard let battingTeamId = battingTeamId,
                  let bowlingTeamId = bowlingTeamId else {
                completion(nil)
                return
            }
            
            var allPlayers: [(String, String, playerStatus, teamType)] = []
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self.getPlayersByTeamId(teamId: battingTeamId) { battingTeamPlayers in
                if let battingTeamPlayers = battingTeamPlayers {
                    for player in battingTeamPlayers {
                        allPlayers.append((player.0, player.1, player.2, .battingTeam))
                    }
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self.getPlayersByTeamId(teamId: bowlingTeamId) { bowlingTeamPlayers in
                if let bowlingTeamPlayers = bowlingTeamPlayers {
                    for player in bowlingTeamPlayers {
                        allPlayers.append((player.0, player.1, player.2, .bowlingTeam))
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                completion(allPlayers)
                print("Got all players \(allPlayers)")
            }
        }
        
    }
    
    func getTeamId(matchId: String, completion: @escaping (String?, String?) -> Void) {
        let db = Firestore.firestore()
        let matchCollection = db.collection("matches")
        matchCollection.document(matchId).getDocument { (doc, err) in
            if let err = err {
                print("Err getting match document: \(err)")
                completion(nil, nil)
            } else if let doc = doc , doc.exists {
                let data = doc.data()
                let bowlingTeamId = data?["bowlingTeamId"] as? String
                let battingTeamId = data?["battingTeamId"] as? String
                completion(battingTeamId, bowlingTeamId)
            } else {
                print("Match document not found")
                completion(nil, nil)
            }
        }
    }
    
    func getPlayersByTeamId(teamId: String, completion: @escaping ([(String, String, playerStatus)]?) -> Void) {
        let db = Firestore.firestore()
        let playersCollection = db.collection("players")
        let query = playersCollection.whereField("teamId", isEqualTo: teamId)
        query.getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil)
                return
            }
            guard let docs = snapshot?.documents else {
                completion(nil)
                return
            }
            var playersList : [(String, String, playerStatus)] = []
            
            for doc in docs {
                let docId = doc.documentID
                let name = doc.data()["name"] as? String ?? ""
                let statusString = doc.data()["status"] as? String
                let status = playerStatus(rawValue: statusString ?? "playing") ?? .playing
                let newPlayer = (docId, name, status)
                playersList.append(newPlayer)
            }
            completion(playersList)
        }
    }
}
