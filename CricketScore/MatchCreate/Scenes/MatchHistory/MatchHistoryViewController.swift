//
//  MatchHistoryViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/2.
//

import Foundation
import UIKit

protocol RoutingProcess: AnyObject {
    func navigateToBattingSetupScene(animated: Bool)
}

class MatchHistoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createMatch(_ sender: UIButton) {
    }
}
