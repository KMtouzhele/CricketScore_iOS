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
        let strikerRunsDic = response.strikerRunsDic
        let strikerBallsFacedDic = response.strikerBallsFacedDic
        
        var battingIndividual: [(striker: String, runs: Int, ballsFaced: Int)] = []
        for (striker, runs) in strikerRunsDic {
            if let ballsFaced = strikerBallsFacedDic[striker] {
                battingIndividual.append((striker: striker, runs: runs, ballsFaced: ballsFaced))
            }
        }
        print("Combined Batter Individual: \(battingIndividual)")
        if battingIndividual.isEmpty{
            viewController?.emptyPrompt.text = "Match has not started yet."
        } else {
            viewController?.tableViewData = battingIndividual
            viewController?.emptyPrompt.isHidden = true
        }
        viewController?.playersTable.reloadData()
    }
}
