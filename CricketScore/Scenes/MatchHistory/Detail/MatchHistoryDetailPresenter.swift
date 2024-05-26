//
//  MatchHistoryDetailPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation

class MatchHistoryDetailPresenter {
    weak var viewController: MatchHistoryDetailViewController?
    func presentMatchDetails(viewModel: MatchHistoryDetailModel.ViewModel) {
        guard viewModel.matchDetailData.count != 0 else {
            viewController?.emptyPrompt.text = "No balls found in this Match"
            return
        }
        viewController?.data = viewModel
        viewController?.table.reloadData()
        viewController?.emptyPrompt.isHidden = true
    }
}
