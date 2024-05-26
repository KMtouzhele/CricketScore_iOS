//
//  BattingSetupPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation

protocol DisplayBattingSetupError: AnyObject {
    func createToast(viewModel: BattingSetupModel.ViewModel.emptyError)
}

class BattingSetupPresenter : PresentBattingSetupMessage {
    weak var viewController: BattingSetupViewController?
    
    func dealWithEmptyResult(emptyResult: Bool, teamId: String){
        if emptyResult == true {
            //create toast
            let errorMessage = "Please don't leave the text fields empty."
            let viewModel = BattingSetupModel.ViewModel.emptyError(errorMessage: errorMessage)
            guard let viewController = viewController else {
                print("viewController is nil")
                return
            }
            viewController.createToast(viewModel: viewModel)
        } else {
            //activate segue
            print("BattingSetupPresenter: Passing BattingTeamId \(teamId) to next screen.")
            viewController?.navigateToBowlingSetup(battingTeamId: teamId)
        }
        
    }
}
