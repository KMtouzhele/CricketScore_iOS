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
    
    
}
