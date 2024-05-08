//
//  IndividualInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import Foundation

protocol RetrievePlayerIndividual: AnyObject {
    func getBatterRuns(matchId: String, completion: @escaping ([String: Int]?, Error?) -> Void)
    func getBatterBallsFaced(matchId: String, completion: @escaping ([String: Int]?, Error?) -> Void)
}

protocol PresentPlayerIndividual: AnyObject {
    func presentBatterIndividual(response: IndividualModel.Response.BatterResponse)
}

class IndividualInteractor: IndividualBusinessLogic {
    let worker = IndividualWorker()
    var presenter: IndividualPresenter
    init(presenter: IndividualPresenter) {
        self.presenter = presenter
    }
    
    func fetchIndividualTracking(matchId: String) {
        //Fetch batters trakcing
        worker.getBatterRuns(matchId: matchId) { (strikerRunsDic, err1) in
            if let err1 = err1 {
                print("Error fetching batter runs: \(err1)")
            } else if let strikerRunsDic = strikerRunsDic {
                print("Successfully get striker-runs dictionary")
                self.worker.getBatterBallsFaced(matchId: matchId) { (strikerBallsFacedDic, err2) in
                    if let err2 = err2 {
                        print("Error fetching batter ballsFaced: \(err2)")
                    } else if let strikerBallsFacedDic = strikerBallsFacedDic {
                        print("Successfully get striker-ballsFaced dictionary")
                        let response = IndividualModel.Response.BatterResponse(
                            strikerRunsDic: strikerRunsDic,
                            strikerBallsFacedDic: strikerBallsFacedDic
                        )
                        print("Get Batter Individual \(response)")
                        self.presenter.presentBatterIndividual(response: response)
                    }
                    
                }
            }
        }
    }
    
    
}
