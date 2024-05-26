//
//  MatchHistoryPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation

class MatchHistoryPresenter {
    weak var viewController: MatchHistoryViewController?
    func presentMatchTeamInfo(matchTeamInfo:[(String, String, String, Int, Int)]) {
        print("MatchHistoryPresenter preseting: \(matchTeamInfo)")
        guard matchTeamInfo.count != 0 else {
            viewController?.emptyPrompt.text = "No Match History Found."
            return
        }
        viewController?.data = matchTeamInfo
        viewController?.table.reloadData()
        viewController?.emptyPrompt.isHidden = true
    }

}
