//
//  SettingsPresenter.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation

class SettingsPresenter {
    weak var viewController: SettingsViewController?
    func convertAllPlayersToViewModel(allPlayers: [(String, String, playerStatus, teamType)]){
        var viewModel = SettingsModel.ViewModel(
            players: []
        )
        for player in allPlayers {
            let id = player.0
            let playerName = player.1
            let playerStatus = player.2
            let playerTeamType = player.3
            viewModel.players.append(
                (playerId: id, name: playerName, status: playerStatus, teamType: playerTeamType)
            )
        }
        viewController?.data = viewModel
        viewController?.table.reloadData()
        viewController?.emptyPrompt.isHidden = true
    }
}
