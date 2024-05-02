//
//  BattingSetupViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/4/30.
//
import Foundation
import UIKit

protocol BattingSetupLogic: AnyObject {
    func emptyValidation(request: BattingSetupModel.Request)
    func assembleTeam(request: BattingSetupModel.Request) -> BattingSetupModel.Response
}

class BattingSetupViewController: UIViewController, DisplayBattingSetupError {
    
    var interactor: BattingSetupLogic?
    var request: BattingSetupModel.Request?
    var presenter = BattingSetupPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = BattingSetupInteractor(presenter: self.presenter)
        self.presenter.viewController = self
        alertLabel.isHidden = true
    }
    
    
    
    func createToast(viewModel: BattingSetupModel.ViewModel.emptyError) {
        alertLabel.text = viewModel.errorMessage
        alertLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.alertLabel.isHidden = true
        }
    }
    
    func navigateToBowlingSetup(battingTeamId: String) {
        performSegue(withIdentifier: "ShowBowlingSetupSegue", sender: battingTeamId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("BattingSetupViewController: Preparing segue to next screen with")
        if segue.identifier == "ShowBowlingSetupSegue" {
                if let battingteamId = sender as? String,
                   let destinationVC = segue.destination as? BowlingSetupViewController {
                    destinationVC.battingTeamId = battingteamId
                }
            }
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
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
        let request = BattingSetupModel.Request(
            teamName: teamNameText,
            playerName1: playerName1Text,
            playerName2: playerName2Text,
            playerName3: playerName3Text,
            playerName4: playerName4Text,
            playerName5: playerName5Text
        )
        self.interactor?.emptyValidation(request: request)

    }
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var playerName5: UITextField!
    @IBOutlet weak var playerName4: UITextField!
    @IBOutlet weak var playerName3: UITextField!
    @IBOutlet weak var playerName2: UITextField!
    @IBOutlet weak var playerName1: UITextField!
}
