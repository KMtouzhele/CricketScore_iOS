//
//  SettingsViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/9.
//

import UIKit

protocol SettingsBusinessLogic: AnyObject {
    func fetchAllPlayers(matchId: String)
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tabBar: TabBarController!
    var data = SettingsModel.ViewModel(
        players: []
    )
    
    var presenter = SettingsPresenter()
    var interactor: SettingsBusinessLogic?
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = SettingsInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        tabBar = self.tabBarController as? TabBarController
        table.dataSource = self
        table.delegate = self
        let matchId = tabBar.summaryViewModel.matchId
        interactor?.fetchAllPlayers(matchId: matchId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBar = self.tabBarController as? TabBarController
        interactor?.fetchAllPlayers(matchId: tabBar.summaryViewModel.matchId)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerViewCell", for: indexPath) as! PlayerViewCell
            let player = data.players[indexPath.row]
            cell.playerId.text = "ID: \(player.playerId)"
            cell.playerName.text = player.name
            cell.teamType.text = player.teamType.rawValue
            cell.playerStatus.text = player.status.rawValue
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
