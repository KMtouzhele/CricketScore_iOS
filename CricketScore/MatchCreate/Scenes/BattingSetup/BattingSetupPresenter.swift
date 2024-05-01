//
//  BattingSetupPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//

import Foundation

protocol DisplayError: AnyObject {
    func createToast(viewModel: SetupList.ViewModel.emptyError)
}

class BattingSetupPresenter : PresentMessage {
    weak var viewController: BattingSetupViewController?
    
    func presentEmptyMessage(){
        let errorMessage = "Please don't leave the text fields empty."
        let viewModel = SetupList.ViewModel.emptyError(errorMessage: errorMessage)
        guard let viewController = viewController else {
            print("viewController is nil")
            return
        }
        viewController.createToast(viewModel: viewModel)
    }
}
