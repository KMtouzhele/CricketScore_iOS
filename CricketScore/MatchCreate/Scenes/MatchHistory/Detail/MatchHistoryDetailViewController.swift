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
    @IBAction func shareMatchDetails(_ sender: UIButton) {
        let jsonData = prepareJsonData()
        do {
            let jsonString = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            if let jsonString = String(data: jsonString, encoding: .utf8) {
                print("JSON String:")
                print(jsonString)
                let activityViewController = UIActivityViewController(activityItems: [jsonString], applicationActivities: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    if let viewController = windowScene.windows.first?.rootViewController {
                        activityViewController.popoverPresentationController?.sourceView = viewController.view
                        viewController.present(activityViewController, animated: true, completion: nil)
                    }
                }
            } else {
                print("Failed to convert data to string")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func prepareJsonData() -> [String: Any] {
        var jsonData = [String: Any]()
        var ballsData = [[String: Any]]()
        for ball in data.matchDetailData {
            var ballData = [String: Any]()
            ballData["ballId"] = ball.ballId
            ballData["strikerName"] = ball.strikerName
            ballData["nonStrikerName"] = ball.nonStrikerName
            ballData["bowlerName"] = ball.bowlerName
            ballData["result"] = ball.result.rawValue
            ballsData.append(ballData)
        }
        jsonData["matchDetailData"] = ballsData
        
        return jsonData
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
