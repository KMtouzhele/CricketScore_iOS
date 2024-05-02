//
//  BowlingSetupPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation

protocol DisplayBowlingSetupError: AnyObject {
    func createToast(viewModel: BattingSetupModel.ViewModel.emptyError)
}
