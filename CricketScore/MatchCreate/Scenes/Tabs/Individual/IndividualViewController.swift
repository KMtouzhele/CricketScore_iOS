//
//  IndividualViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import Foundation
import UIKit

protocol IndividualBusinessLogic: AnyObject {
    func fetchIndividualTracking(matchId: String)
}

class IndividualViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tabBar: TabBarController!
    
    var tableViewData = [("Loading...", 0, 0)]
    
    var interactor: IndividualBusinessLogic?
    var presenter = IndividualPresenter()
    
    @IBOutlet weak var emptyPrompt: UILabel!
    @IBOutlet weak var playersTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: self.playersTable))")
        tabBar = self.tabBarController as? TabBarController
        self.interactor = IndividualInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        playersTable.dataSource = self
        playersTable.delegate = self
        
        interactor?.fetchIndividualTracking(matchId: tabBar.summaryViewModel.matchId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBar = self.tabBarController as? TabBarController
        playersTable.dataSource = self
        interactor?.fetchIndividualTracking(matchId: tabBar.summaryViewModel.matchId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualViewCell", for: indexPath)
        let striker = tableViewData[indexPath.row]
        guard let strikerCell = cell as? IndividualViewCell else {
                return cell
            }
        strikerCell.strikerName.text = striker.0
        strikerCell.runs.text = String(striker.1)
        strikerCell.ballsFaced.text = String(striker.2)
        return strikerCell
    }
}
