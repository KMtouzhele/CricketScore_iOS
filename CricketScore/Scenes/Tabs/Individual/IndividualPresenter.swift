//
//  IndividualPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import Foundation

class IndividualPresenter: PresentPlayerIndividual {
    weak var viewController: IndividualViewController?
    
    //https://chatgpt.com/c/2d0b55d9-c90a-49ca-9fb7-d783a3985dcd
    func presentBatterIndividual(response: IndividualModel.Response.BatterResponse) {
        let strikerNamesDic = response.strikerNamesDic
        let strikerRunsDic = response.strikerRunsDic
        let strikerBallsFacedDic = response.strikerBallsFacedDic
        
        var battingIndividual: [(striker: String, name: String, runs: Int, ballsFaced: Int)] = []
        for (striker, runs) in strikerRunsDic {
            if let ballsFaced = strikerBallsFacedDic[striker],
            let name = strikerNamesDic[striker]
            {
                battingIndividual.append((striker: striker, name: name, runs: runs, ballsFaced: ballsFaced))
            }
        }
        print("Combined Batter Individual: \(battingIndividual)")
        if battingIndividual.isEmpty{
            viewController?.emptyPrompt.text = "Match has not started yet."
        } else {
            viewController?.emptyPrompt.isHidden = true
            viewController?.data.strikers = battingIndividual
        }
        viewController?.strikersTable.reloadData()
    }
    
    func presentBowlerIndividual(response: IndividualModel.Response.BowlerResponse) {
        let bowlerNamesDic = response.bowlerNamesDic
        let bowlerRunsLostDic = response.bowlerRunsLostDic
        let bowlerWicketsDic = response.bowlerWicketsDic
        let bowlerBallsDeliveredDic = response.bowlerBallsDeliveredDic
        print("Presenter got bowlerRunsLostDic: \(bowlerRunsLostDic)")
        print("Presenter got bowlerWicketsDic: \(bowlerWicketsDic)")
        print("Presenter got bowlerBallsDeliveredDic: \(bowlerBallsDeliveredDic)")
        
        var bowlerIndividual: [(bowler: String, name: String, runsLost: Int, ballsDelivered: Int, wickets: Int)] = []
        for (bowler, runsLost) in bowlerRunsLostDic {
            if let ballsDelivered = bowlerBallsDeliveredDic[bowler],
               let wicket = bowlerWicketsDic[bowler],
               let name = bowlerNamesDic[bowler]
            {
                bowlerIndividual.append((bowler: bowler, name: name, runsLost: runsLost, ballsDelivered: ballsDelivered, wickets: wicket))
            }
        }
        print("Combined Bowler Individual: \(bowlerIndividual)")
        if bowlerIndividual.isEmpty {
            viewController?.emptyPrompt.text = "Match has not started yet."
        } else {
            viewController?.emptyPrompt.isHidden = true
            viewController?.data.bowlers = bowlerIndividual
        }
        viewController?.bowlerTable.reloadData()
    }
}
