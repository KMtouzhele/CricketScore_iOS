//
//  IndividualWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import Foundation
import FirebaseFirestore
import FirebaseSharedSwift

class IndividualWorker : RetrievePlayerIndividual {
    func getBatterBallsFaced(matchId: String, completion: @escaping ([String : Int]?, (any Error)?) -> Void) {
        let db = Firestore.firestore()
        let ballCollection = db.collection("balls")
        let query = ballCollection.whereField("matchId", isEqualTo: matchId)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let docs = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            var strikerBallsFacedDic: [String: Int] = [:]
            
            for doc in docs {
                let data = doc.data()
                
                if let striker = data["striker"] as? String,
                   let isBallDelivered = data["isBallDelivered"] as? Bool {
                    if let exsistingBallsFaced = strikerBallsFacedDic[striker] {
                        strikerBallsFacedDic[striker] = exsistingBallsFaced + (isBallDelivered ? 1 : 0)
                    } else {
                        strikerBallsFacedDic[striker] = isBallDelivered ? 1 : 0
                    }
                }
            }
            completion(strikerBallsFacedDic, nil)
        }
    }
    
    func getBatterRuns(matchId: String, completion: @escaping ([String : Int]?, (any Error)?) -> Void) {
        let db = Firestore.firestore()
        let ballCollection = db.collection("balls")
        
        let query = ballCollection.whereField("matchId", isEqualTo: matchId)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let docs = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            var strikerRunsDic: [String: Int] = [:]
            
            for doc in docs {
                let data = doc.data()
                
                if let striker = data["striker"] as? String,
                   let runs = data["runs"] as? Int {
                    if let exsistingRuns = strikerRunsDic[striker] {
                        strikerRunsDic[striker] = exsistingRuns + runs
                    } else {
                        strikerRunsDic[striker] = runs
                    }
                }
            }
            completion(strikerRunsDic, nil)
        }
    }
    
    func getBowlerRunsLost(matchId: String, completion: @escaping ([String : Int]?, (any Error)?) -> Void) {
        let db = Firestore.firestore()
        let ballCollection = db.collection("balls")
        
        let query = ballCollection.whereField("matchId", isEqualTo: matchId)
        
        query.getDocuments{ (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let docs = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            var bowlerRunsLostDic: [String: Int] = [:]
            
            for doc in docs {
                let data = doc.data()
                
                if let bowler = data["bowler"] as? String,
                   let runsLost = data["runs"] as? Int {
                    if let existingRunsLost = bowlerRunsLostDic[bowler] {
                        bowlerRunsLostDic[bowler] = existingRunsLost + runsLost
                    } else {
                        bowlerRunsLostDic[bowler] = runsLost
                    }
                }
            }
            completion(bowlerRunsLostDic, nil)
        }
    }
    
    func getBowlerBallsDelivered(matchId: String, completion: @escaping ([String : Int]?, (any Error)?) -> Void) {
        let db = Firestore.firestore()
        let ballCollection = db.collection("balls")
        
        let query = ballCollection.whereField("matchId", isEqualTo: matchId)
        
        query.getDocuments{ (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let docs = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            var bowlerBallsDeliveredDic: [String: Int] = [:]
            
            for doc in docs {
                let data = doc.data()
                
                if let bowler = data["bowler"] as? String,
                   let isBallDelivered = data["isBallDelivered"] as? Bool {
                    if let existingBallsDelivered = bowlerBallsDeliveredDic[bowler] {
                        bowlerBallsDeliveredDic[bowler] = existingBallsDelivered + (isBallDelivered ? 1 : 0)
                    } else {
                        bowlerBallsDeliveredDic[bowler] = isBallDelivered ? 1 : 0
                    }
                }
            }
            completion(bowlerBallsDeliveredDic, nil)
        }
    }
    
    func getBowlerWickets(matchId: String, completion: @escaping ([String : Int]?, (any Error)?) -> Void) {
        let db = Firestore.firestore()
        let ballCollection = db.collection("balls")
        
        let query = ballCollection.whereField("matchId", isEqualTo: matchId)
        
        query.getDocuments{ (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let docs = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            var bowlerWicketsDic: [String: Int] = [:]
            
            for doc in docs {
                let data = doc.data()
                var isWicket: Int
                
                if let bowler = data["bowler"] as? String,
                   let resultString = data["result"] as? String,
                   let result = ballType(rawValue: resultString) {
                    switch result {
                    case .bowled, .caught, .caughtBowled, .hitWicket, .lbw, .runOut, .stumping:
                        isWicket = 1
                    default: isWicket = 0
                    }
                    if let wickets = bowlerWicketsDic[bowler] {
                        bowlerWicketsDic[bowler] = wickets + isWicket
                    } else {
                        bowlerWicketsDic[bowler] = isWicket
                    }
                }
            }
            completion(bowlerWicketsDic, nil)
        }
    }
    
    func getPlayerName(playerId: String, completion: @escaping (String?, Error?) -> Void) {
        let db = Firestore.firestore()
        let playersCollection = db.collection("players").document(playerId)
            
        playersCollection.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
            } else if let document = document, document.exists {
                if let playerName = document.data()?["name"] as? String {
                    completion(playerName, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    
    
}
