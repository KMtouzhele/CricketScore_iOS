//
//  SettingsInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation

class SettingsInteractor: SettingsBusinessLogic {
    let worker = SettingsWorker()
    var presenter: SettingsPresenter
    init(presenter: SettingsPresenter) {
        self.presenter = presenter
    }
    func fetchAllPlayers(matchId: String) {
        worker.getPlayers(matchId: matchId) { allPlayers in
            guard let allPlayers = allPlayers else {
                print("Error fetching all players")
                return
            }
            print("All players: \(allPlayers)")
            self.presenter.convertAllPlayersToViewModel(allPlayers: allPlayers)
        }
    }
}
