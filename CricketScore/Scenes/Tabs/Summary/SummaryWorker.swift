//
//  SummaryWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/7.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SummaryWorker: RetrieveTeamInfo {
    
    func getTeamNameById(teamId: String, completion: @escaping(String?) -> Void) {
        let db = Firestore.firestore()
        let teamCollection = db.collection("teams")
        teamCollection.document(teamId).getDocument { (document, error) in
            if let error = error {
                print("Error getting team document: \(error)")
                completion(nil)
            } else if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String
                completion(name)
            } else {
                print("Team document not found")
                completion(nil)
            }
        }
    }
}
