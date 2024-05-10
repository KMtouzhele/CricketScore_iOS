//
//  MatchHistoryViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation
import UIKit

protocol MatchHistoryBusinessLogic: AnyObject {
    func fetchTeamNames()
}

class MatchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data : [(String, String, String, Int, Int)] = []
    
    var interactor: MatchHistoryBusinessLogic?
    var presenter = MatchHistoryPresenter()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = MatchHistoryInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        
        self.interactor?.fetchTeamNames()
        
        table.dataSource = self
        table.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowMatchHistoryDetail"{
            guard let historyDetailVC = segue.destination as? MatchHistoryDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMatchCell = sender as? MatchHistoryCell else {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            guard let indexPath = table.indexPath(for: selectedMatchCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMatch = data[indexPath.row]
            
            historyDetailVC.matchId = selectedMatch.0
            historyDetailVC.matchIndex = indexPath.row
        }
    }

    @IBAction func createMatch(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView == table else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHistoryCell", for: indexPath) as! MatchHistoryCell
        let match = data[indexPath.row]
        cell.matchId = match.0
        cell.battingTeamName.text = match.1
        cell.bowlingTeamName.text = match.2
        cell.totalWickets.text = String(match.3)
        cell.totalRuns.text = String(match.4)

        return cell
    }
}
