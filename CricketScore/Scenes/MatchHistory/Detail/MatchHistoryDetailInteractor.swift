//
//  MatchHistoryDetailInteractor.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import Foundation

protocol FetchBallsFromFirestore: AnyObject {
    func fetchBallsByMatchId(matchId: String, completion: @escaping ([(String,String, String, String, ballType)]?) -> Void)
}
class MatchHistoryDetailInteractor: MatchDetailBusinessLogic {
    let worker = MatchHistoryDetailWorker()
    let presenter: MatchHistoryDetailPresenter
    init(presenter: MatchHistoryDetailPresenter) {
        self.presenter = presenter
    }
    func fetchBalls(matchId: String) {
        worker.fetchBallsByMatchId(matchId: matchId) { balls in
            guard let balls = balls else{
                print("Err fetching balls")
                return
            }
            let viewModel = MatchHistoryDetailModel.ViewModel(matchDetailData: balls)
            self.presenter.presentMatchDetails(viewModel: viewModel)
        }
    }
}
