//
//  SummaryPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import Foundation

protocol DisplaySummary: AnyObject {
    func displayTeamNames(viewModel: SummaryModel.ViewModel.teamNames)
}

class SummaryPresenter: PresentTeamInfo {
    weak var viewController: SummaryViewController?
    
    func presentTeamNames(response: SummaryModel.Response) {
        let viewModel = SummaryModel.ViewModel.teamNames(
            battingTeamName: response.battingTeamName,
            bowlingTeamName: response.bowlingTeamName
        )
        viewController?.displayTeamNames(viewModel: viewModel)
        viewController?.battingTeamName = viewModel.battingTeamName
        viewController?.bowlingTeamName = viewModel.bowlingTeamName
        
    }
}
