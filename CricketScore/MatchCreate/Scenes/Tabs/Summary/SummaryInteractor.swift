//
//  SummaryInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/7.
//

import Foundation

protocol RetrieveTeamInfo: AnyObject {
    func getTeamNameById(teamId: String, completion: @escaping(String?) -> Void)
}

protocol PresentTeamInfo: AnyObject {
    func presentTeamNames(response: SummaryModel.Response)
}

class SummaryInteractor: SummaryViewBusinessLogic {
    let worker = SummaryWorker()
    var presenter: SummaryPresenter
    init(presenter: SummaryPresenter) {
        self.presenter = presenter
    }
    
    func getTeamName(request: SummaryModel.Request){
        worker.getTeamNameById(teamId: request.battingteamId) { [weak self] (battingTeamName: String?) in
            guard let self = self else { return }
            let battingName = battingTeamName ?? ""
            self.worker.getTeamNameById(teamId: request.bowlingteamId) { (bowlingTeamName: String?) in
                let bowlingName = bowlingTeamName ?? ""
                let response = SummaryModel.Response(
                    battingTeamName: battingName,
                    bowlingTeamName: bowlingName
                )
                self.presenter.presentTeamNames(response: response)
            }
        }
    }
}
