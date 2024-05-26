//
//  BowlingSetupPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation

protocol DisplayBowlingSetupError: AnyObject {
    func createToast(viewModel: BowlingSetupModel.ViewModel.emptyError)
}

class BowlingSetupPresenter: PresentBowlingSetupMessage {
    
    weak var viewController: BowlingSetupViewController?
    
    func presentEmptyMessage() {
        let errorMessage = "Please don't leave the text fields empty."
        let viewModel = BowlingSetupModel.ViewModel.emptyError(errorMessage: errorMessage)
        guard let viewController = viewController else {
            print("viewController is nil")
            return
        }
        viewController.createToast(viewModel: viewModel)
    }
    
    func presentNextPage(battingTeamId: String, bowlingTeamId: String, matchID: String){
        viewController?.navigateToScoreBoard(
            battingTeamId: battingTeamId,
            bowlingTeamId: bowlingTeamId,
            matchId: matchID
        )
    }
    
    
}
