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
        viewController?.data = viewModel
        viewController?.table.reloadData()
    }
}
