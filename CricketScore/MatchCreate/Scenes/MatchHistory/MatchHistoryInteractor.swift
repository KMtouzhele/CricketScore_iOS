//
//  MatchHistoryInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation

class MatchHistoryInteractor: MatchHistoryBusinessLogic {
    let worker = MatchHistoryWorker()
    let presenter:MatchHistoryPresenter
    
    init(presenter: MatchHistoryPresenter) {
        self.presenter = presenter
    }
    
    func fetchTeamNames(){
        print("MatchHistory fetching...")
        worker.getMatchTeamNames{ matchTeams in
            guard let matchTeams = matchTeams else {
                print("Err fetching matchTeams info")
                return
            }
            self.presenter.presentMatchTeamInfo(matchTeamInfo: matchTeams)
        }
    }
}
