//
//  BowlingSetupViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation
import UIKit

protocol BowlingSetupLogic: AnyObject {
    func prepareToFirestore(request: BowlingSetupModel.Request, completion: @escaping (String?, String?) -> Void)
}

class BowlingSetupViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    var battingTeamId: String?
    var bowlingTeamId: String?
    var matchId: String?
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
    
    func navigateToScoreBoard(battingTeamId: String, bowlingTeamId: String, matchId: String) {
        self.battingTeamId = battingTeamId
        self.bowlingTeamId = bowlingTeamId
        self.matchId = matchId
        performSegue(withIdentifier: "ShowScoreBoardSegue", sender: nil)
        print("SegueToScoring \(String(describing: self.battingTeamId)) \(String(describing: self.bowlingTeamId)) \(String(describing: self.matchId))")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowScoreBoardSegue" {
            if let destinationVC = segue.destination as? UITabBarController {
                if let scoringVC = destinationVC.viewControllers?[0] as? ScoringViewController{
                    scoringVC.battingTeamId = self.battingTeamId
                    scoringVC.bowlingTeamId = self.bowlingTeamId
                    scoringVC.matchId = self.matchId
                }
                
            }
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
        self.interactor?.prepareToFirestore(request: request, completion: { bowlingTeamId, matchId in
            self.bowlingTeamId = bowlingTeamId
            self.matchId = matchId
            print("VC: \(String(describing: self.bowlingTeamId)) and \(String(describing: self.matchId))")
        })
    }
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var playerName1: UITextField!
    @IBOutlet weak var playerName2: UITextField!
    @IBOutlet weak var playerName3: UITextField!
    @IBOutlet weak var playerName4: UITextField!
    @IBOutlet weak var playerName5: UITextField!
    @IBOutlet weak var playerImg1: UIImageView!
    @IBOutlet weak var playerImg2: UIImageView!
    @IBOutlet weak var playerImg3: UIImageView!
    @IBOutlet weak var playerImg4: UIImageView!
    @IBOutlet weak var playerImg5: UIImageView!
    @IBAction func playerImgOnTap1(_ sender: UIButton) {
        callImagePicker(for: sender)
    }
    @IBAction func playerImgOnTap2(_ sender: UIButton) {
        callImagePicker(for: sender)
    }
    @IBAction func playerImgOnTap3(_ sender: UIButton) {
        callImagePicker(for: sender)
    }
    @IBAction func playerImgOnTap4(_ sender: UIButton) {
        callImagePicker(for: sender)
    }
    @IBAction func playerImgOnTap5(_ sender: UIButton) {
        callImagePicker(for: sender)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            switch selectedButtonTag {
            case 1:
                playerImg1.image = image
            case 2:
                playerImg2.image = image
            case 3:
                playerImg3.image = image
            case 4:
                playerImg4.image = image
            case 5:
                playerImg5.image = image
            default:
                break
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    var selectedButtonTag: Int?
    func callImagePicker(for button: UIButton){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("Gallery available")
            
            selectedButtonTag = button.tag
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
