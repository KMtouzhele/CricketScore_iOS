//
//  MatchHistoryWorker.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchHistoryWorker {
    let db = Firestore.firestore()
    
    func getMatchTeamNames(completion: @escaping ([(String, String, String, Int, Int)]?) -> Void) {
        let matchCollection = db.collection("matches")
        matchCollection.getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil)
                return
            }
            guard let docs = snapshot?.documents else {
                completion(nil)
                return
            }
            var teamIdArray: [(String, String, String)] = []
            for doc in docs {
                let data = doc.data()
                let matchId = doc.documentID
                let battingTeamId = data["battingTeamId"] as? String ?? ""
                let bowlingTeamId = data["bowlingTeamId"] as? String ?? ""
                let newMatch = (matchId, battingTeamId, bowlingTeamId)
                teamIdArray.append(newMatch)
            }
            print("TeamIdArray: \(teamIdArray)")
            self.getTeamName(matchTeamIdArray: teamIdArray) { teamNames in
                guard let teamNames = teamNames else {
                    completion(nil)
                    return
                }
                var teamNamesWithResults: [(String, String, String, Int, Int)] = []
                print("TeamNameArray: \(teamNames)")
                let dispatchGroup = DispatchGroup()
                for teamName in teamNames {
                    let matchId = teamName.0
                    dispatchGroup.enter()
                    self.getResultByMatchId(matchId: matchId) { result in
                        if let result = result {
                            teamNamesWithResults.append((teamName.0, teamName.1, teamName.2, result.1, result.2))
                            
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    print("teamNamesWithResults: \(teamNamesWithResults)")
                    completion(teamNamesWithResults)
                }
            }
        }
    }
    
    func getTeamName(
        matchTeamIdArray:[(String, String, String)],
        completion:  @escaping ([(String, String, String)]?) -> Void
    ) {
        var teamNames: [(String, String, String)] = []
        let dispatchGroup = DispatchGroup()
        for match in matchTeamIdArray {
            let battingTeamId = match.1
            let bowlingTeamId = match.2
            dispatchGroup.enter()
            getTeamNameByTeamId(battingTeamId) { battingTeamName in
                self.getTeamNameByTeamId(bowlingTeamId) { bowlingTeamName in
                    if let battingTeamName = battingTeamName, let bowlingTeamName = bowlingTeamName {
                        teamNames.append((match.0, battingTeamName, bowlingTeamName))
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(teamNames)
        }
    }
    
    func getTeamNameByTeamId(_ teamId: String, completion: @escaping (String?) -> Void){
        let teamsCollection = db.collection("teams")
        teamsCollection.document(teamId).getDocument { (doc, err) in
            if err != nil {
                completion(nil)
            } else if let doc = doc, doc.exists {
                let data = doc.data()
                let teamName = data?["name"] as? String
                completion(teamName)
            } else {
                completion(nil)
            }
        }
        
    }
    
    func getResultByMatchId(matchId: String, completion: @escaping ((String, Int, Int)?) -> Void) {
        let ballCollection = db.collection("balls")
        let query = ballCollection.whereField("matchId", isEqualTo: matchId)
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("Error fetching match results: \(err!.localizedDescription)")
                completion(nil)
                return
            }
            guard let docs = snapshot?.documents else {
                print("No documents found for matchId: \(matchId)")
                completion(nil)
                return
            }
            
            var matchResult: (String, Int, Int) = ("",0,0)
            var wickets = 0
            var runs = 0
            print("MatchResult: \(matchResult)")
            for doc in docs {
                var boundaryRuns = 0
                let data = doc.data()
                if let resultString = data["result"] as? String,
                   let result = ballType(rawValue: resultString),
                   let newRuns = data["runs"] as? Int {
                    print("result: \(result)")
                    switch result {
                    case .bowled, .caught, .caughtBowled, .hitWicket, .lbw, .runOut, .stumping:
                        wickets = wickets + 1
                    case .fourBoundary:
                        boundaryRuns = 4
                    case .sixBoundary:
                        boundaryRuns = 6
                    default: break
                    }
                    runs = runs + newRuns + boundaryRuns
                    print("runs: \(runs)")
                }
            }
            matchResult = (matchId, wickets, runs)
            print("MatchResult: \(matchResult)")
            completion(matchResult)
        }

    }
}
