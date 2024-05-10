//
//  SettingsDetailViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingsDetailViewController: UIViewController {
    
    
    var playerDetail: (playerId: String, name: String, status: playerStatus, teamType: teamType)?
    var index: Int?

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var playerId: UILabel!
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var playerTeamType: UILabel!
    @IBOutlet weak var playerStatus: UILabel!
    @IBOutlet weak var naviBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let playerDetail = playerDetail {
            disableDelete(playerDetial: playerDetail)
            naviBar.isTranslucent = true
            playerId.text = playerDetail.playerId
            playerName.text = playerDetail.name
            playerStatus.text = playerDetail.status.rawValue
            playerTeamType.text = playerDetail.teamType.rawValue
        }
    }

    @IBAction func onSave(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Saving..."
        let response = SettingsModel.Response.updatePlayerResponse(
            playerId: playerId.text ?? "",
            updatedName: playerName.text ?? ""
        )
        updatePlayer(response: response)
    }
    
    //https://chat.openai.com/share/bed28cb9-80be-49d2-8159-7f42273ba4d7
    @IBAction func onDelete(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Deleting player",
            message: "You have no chance to recover. Are you sure to proceed?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let delete = UIAlertAction(title: "DELETE", style: .destructive) { [self] (action:UIAlertAction) in
            let response = SettingsModel.Response.updatePlayerResponse(
                playerId: playerId.text ?? "",
                updatedName: playerName.text ?? ""
            )
            deletePlayer(response: response)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(delete)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func updatePlayer(response: SettingsModel.Response.updatePlayerResponse){
        let playerId = response.playerId
        let newName = response.updatedName
        let db = Firestore.firestore()
        let playerCollection = db.collection("players")
        playerCollection.document(playerId)
            .updateData(["name": newName]){ err in
                if let err = err {
                    print("Error updating player document: \(err)")
                } else {
                    print("Player document successfully updated with new name.")
                    self.performSegue(withIdentifier: "saveSegue", sender: nil)
                }
            }
    }
    
    private func deletePlayer(response: SettingsModel.Response.updatePlayerResponse){
        let playerId = response.playerId
        let newName = response.updatedName
        let db = Firestore.firestore()
        let playerCollection = db.collection("players")
        let doc = playerCollection.document(playerId)
        doc.delete { err in
            if let err = err{
                print("Error deleting player document: \(err)")
            } else {
                print("Player document successfully deleted.")
                self.performSegue(withIdentifier: "saveSegue", sender: nil)
            }
        }
    }
    
    private func disableDelete(playerDetial: (playerId: String, name: String, status: playerStatus, teamType: teamType)){
        switch playerDetial.status {
        case .available:
            btnDelete.isEnabled = true
        case .dismissed, .playing:
            btnDelete.isEnabled = false
        }
    }
    
}
