//
//  ScoringPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/4.
//

import Foundation

protocol UpdateScoreBoard {
    func displayScoreBoard(viewModel: ScoringModel.ViewModel.score)
}

class ScoringPresenter: PresentSocreBoard {
    weak var viewController: ScoringViewController?
    
//    func assembleScoreViewModel(response: ScoringModel.Response.bassResponse) -> ScoringModel.ViewModel.score {
//        return
//    }
    
    func assembleTeamPlayersViewModel(response: ScoringModel.Response.playersResponse) {
        let battersDictionary = response.batterNames
        let bowlersDictionary = response.bowlerNames
        viewController?.battingTeamDic = battersDictionary
        viewController?.bowlingTeamDic = bowlersDictionary
    }
    
}
