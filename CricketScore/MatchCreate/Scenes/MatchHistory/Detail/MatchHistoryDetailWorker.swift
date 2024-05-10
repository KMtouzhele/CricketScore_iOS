//
//  MatchHistoryDetailWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchHistoryDetailWorker: FetchBallsFromFirestore {
    let db = Firestore.firestore()
    
    func fetchBallsByMatchId(matchId: String, completion: @escaping ([(String,String, String, String, ballType)]?) -> Void) {
        let ballCollection = db.collection("balls")
        let query = ballCollection.whereField("matchId", isEqualTo: matchId)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil)
                return
            }
            
            guard let docs = snapshot?.documents else {
                completion(nil)
                return
            }
            var balls: [(String,String,String,String,ballType)] = []
            let dispatchGroup = DispatchGroup()
            
            for doc in docs {
                let data = doc.data()
                if let strikerId  = data["striker"] as? String,
                   let nonStrikerId = data["nonStriker"] as? String,
                   let bowlerId = data["bowler"] as? String,
                   let resultString = data["result"] as? String,
                   let result = ballType(rawValue: resultString)
                {
                    dispatchGroup.enter()
                    self.fetchPlayerNameByPlayerId(playerId: strikerId) { strikerName in
                        self.fetchPlayerNameByPlayerId(playerId: nonStrikerId) { nonStrikerName in
                            self.fetchPlayerNameByPlayerId(playerId: bowlerId) { bowlerName in
                                let newBall = (doc.documentID, strikerName ?? "", nonStrikerName ?? "", bowlerName ?? "", result)
                                balls.append(newBall)
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(balls)
            }
        }
    }
    
    func fetchPlayerNameByPlayerId(playerId: String, completion: @escaping (String?) -> Void) {
        let playerCollection = db.collection("players")
        playerCollection.document(playerId).getDocument { (doc, err) in
            if err != nil {
                completion(nil)
                return
            }
            guard let doc = doc , doc.exists else {
                completion(nil)
                return
            }
            let data = doc.data()
            let name = data?["name"] as? String
            completion(name)
        }
    }
    
}
