//
//  MatchHistoryDetailViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import UIKit

protocol MatchDetailBusinessLogic: AnyObject {
    func fetchBalls(matchId: String)
}

class MatchHistoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var data = MatchHistoryDetailModel.ViewModel(matchDetailData: [])
    var matchIndex: Int = 0
    var matchId = ""
    
    var interactor: MatchHistoryDetailInteractor?
    var presenter = MatchHistoryDetailPresenter()

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HistoryDetail: \(matchId)")
        self.interactor = MatchHistoryDetailInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        table.dataSource = self
        table.delegate = self
        interactor?.fetchBalls(matchId: matchId)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.matchDetailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView == table else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHistoryDetailTableViewCell", for: indexPath) as! MatchHistoryDetailTableViewCell
        let ball = data.matchDetailData[indexPath.row]
        cell.strikerName.text = ball.strikerName
        cell.nonStrikerName.text = ball.nonStrikerName
        cell.bowlerName.text = ball.bowlerName
        cell.result.text = ball.result.rawValue
        cell.ballId = ball.ballId
        return cell
    }
    
}
