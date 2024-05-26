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
                
                let playerIds = Array(strikerRunsDic.keys)
                var strikerNamesDic: [String: String] = [:]
                let dispatchGroup = DispatchGroup()
                for playerId in playerIds {
                    dispatchGroup.enter()
                    self.worker.getPlayerName(playerId: playerId) { (name, error) in
                        if let name = name {
                            strikerNamesDic[playerId] = name
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.worker.getBatterBallsFaced(matchId: matchId) { (strikerBallsFacedDic, err2) in
                        if let err2 = err2 {
                            print("Error fetching batter ballsFaced: \(err2)")
                        } else if let strikerBallsFacedDic = strikerBallsFacedDic {
                            print("Successfully get striker-ballsFaced dictionary")
                            let response = IndividualModel.Response.BatterResponse(
                                strikerNamesDic: strikerNamesDic,
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
        
        worker.getBowlerRunsLost(matchId: matchId) { (bowlerRunsLostDic, err1) in
            if let err1 = err1 {
                print("Error fetching bowler runslost: \(err1)")
            } else if let bowlerRunsLostDic = bowlerRunsLostDic {
                print("Successfully get bowler-runsLost dictionary")
                let playerIds = Array(bowlerRunsLostDic.keys)
                var bowlerNamesDic: [String: String] = [:]
                let dispatchGroup = DispatchGroup()
                for id in playerIds {
                    dispatchGroup.enter()
                    self.worker.getPlayerName(playerId: id){ (name, error) in
                        if let name = name {
                            bowlerNamesDic[id] = name
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.worker.getBowlerBallsDelivered(matchId: matchId) { (bowlerBallsDeliveredDic, err2) in
                        if let err2 = err2 {
                            print("Error fetching bowler ballsDelivered: \(err2)")
                        } else if let bowlerBallsDeliveredDic = bowlerBallsDeliveredDic {
                            print("Successfully get bowler-ballsDelivered Dictionary")
                            self.worker.getBowlerWickets(matchId: matchId){ (bowlerWicketsDic, err3) in
                                if let err3 = err3 {
                                    print("Error fetching bowler wickets: \(err3)")
                                } else if let bowlerWicketDic = bowlerWicketsDic {
                                    print("Successfully get bowler-wickets dictionary")
                                    let response = IndividualModel.Response.BowlerResponse(
                                        bowlerNamesDic: bowlerNamesDic,
                                        bowlerRunsLostDic: bowlerRunsLostDic,
                                        bowlerBallsDeliveredDic: bowlerBallsDeliveredDic,
                                        bowlerWicketsDic: bowlerWicketDic
                                    )
                                    print("Get Bowler Individual: \(response)")
                                    self.presenter.presentBowlerIndividual(response: response)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
}
