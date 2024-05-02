//
//  BowlingSetupViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation
import UIKit

protocol BowlingSetupLogic: AnyObject {
    func prepareToFirestore(request: BowlingSetupModel.Request)
}

class BowlingSetupViewController: UIViewController {
    var battingTeamId: String?
    var interactor: BowlingSetupLogic?
    var request: BowlingSetupModel.Request?
    var presenter = BowlingSetupPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = BowlingSetupInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        alertLabel.isHidden = true
    }
    
    func createToast(viewModel: BowlingSetupModel.ViewModel.emptyError){
        alertLabel.text = viewModel.errorMessage
        alertLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.alertLabel.isHidden = true
        }
    }
    
    @IBAction func startMatch(_ sender: UIButton) {
        print("Match Starts Button was tapped.")
        guard let teamNameText = teamName.text,
              let playerName1Text = playerName1.text,
              let playerName2Text = playerName2.text,
              let playerName3Text = playerName3.text,
              let playerName4Text = playerName4.text,
              let playerName5Text = playerName5.text
        else {
            print("BATTING SETUP VIEW CONTROLLER: At least one of the text fields is nil")
            return
        }
        let request = BowlingSetupModel.Request(
            teamName: teamNameText,
            playerName1: playerName1Text,
            playerName2: playerName2Text,
            playerName3: playerName3Text,
            playerName4: playerName4Text,
            playerName5: playerName5Text,
            battingTeamId: self.battingTeamId!
        )
        print("request is generated!")
        self.interactor?.prepareToFirestore(request: request)
    }
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var playerName1: UITextField!
    @IBOutlet weak var playerName2: UITextField!
    @IBOutlet weak var playerName3: UITextField!
    @IBOutlet weak var playerName4: UITextField!
    @IBOutlet weak var playerName5: UITextField!
}
