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
//https://chatgpt.com/c/9809a356-81fd-4ac3-a216-55b98ee7084c

class IndividualViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tabBar: TabBarController!
    
    var data = IndividualModel.tableData(
        strikers: [],
        bowlers: [])
    
    var currentShowingTeam = teamType.battingTeam
    
    var interactor: IndividualBusinessLogic?
    var presenter = IndividualPresenter()
    
    @IBOutlet weak var emptyPrompt: UILabel!
    @IBOutlet weak var strikersTable: UITableView!
    @IBOutlet weak var bowlerTable: UITableView!
    @IBOutlet weak var btnBatting: UIButton!
    @IBAction func btnBattingTapped(_ sender: UIButton) {
//        strikersTable.dataSource = self
//        interactor?.fetchIndividualTracking(matchId: tabBar.summaryViewModel.matchId)
        btnBowling.alpha = 0.5
        btnBatting.alpha = 1
        currentShowingTeam = .battingTeam
        strikersTable.isHidden = false
        bowlerTable.isHidden = true

    }
    
    @IBOutlet weak var btnBowling: UIButton!
    @IBAction func btnBowlingTapped(_ sender: UIButton) {
//        bowlerTable.dataSource = self
//        interactor?.fetchIndividualTracking(matchId: tabBar.summaryViewModel.matchId)
        btnBowling.alpha = 1
        btnBatting.alpha = 0.5
        currentShowingTeam = .bowlingTeam
        bowlerTable.isHidden = false
        strikersTable.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strikersTable.dataSource = self
        strikersTable.delegate = self
        btnBowling.alpha = 0.5
        btnBatting.alpha = 1
        strikersTable.isHidden = false
        bowlerTable.isHidden = true
        print("\(String(describing: self.strikersTable))")
        tabBar = self.tabBarController as? TabBarController
        self.interactor = IndividualInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        bowlerTable.dataSource = self
        bowlerTable.delegate = self
        interactor?.fetchIndividualTracking(matchId: tabBar.summaryViewModel.matchId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBar = self.tabBarController as? TabBarController
        strikersTable.dataSource = self
        bowlerTable.dataSource = self
        interactor?.fetchIndividualTracking(matchId: tabBar.summaryViewModel.matchId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == strikersTable {
            return data.strikers.count
        } else {
            return data.bowlers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == strikersTable {
            print("it's strikerTable")
            let cell = tableView.dequeueReusableCell(withIdentifier: "StrikerViewCell", for: indexPath) as! StrikerViewCell
            let striker = data.strikers[indexPath.row]
            cell.strikerName.text = striker.name
            cell.ballsFaced.text = String(striker.ballsFaced)
            cell.runs.text = String(striker.runs)
            return cell
        } else if tableView == bowlerTable {
            print("it's bowlerTable")
            let cell = tableView.dequeueReusableCell(withIdentifier: "BowlerViewCell", for: indexPath) as! BowlerViewCell
            let bowler = data.bowlers[indexPath.row]
            cell.bowlerName.text = bowler.name
            cell.ballsDelivered.text = String(bowler.ballsDelivered)
            cell.runsLost.text = String(bowler.runsLost)
            cell.wickets.text = String(bowler.wickets)
            return cell
        } else {
            print("No table")
            return UITableViewCell()
        }
    }
}
