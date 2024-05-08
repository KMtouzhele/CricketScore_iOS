//
//  IndividualViewController.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import Foundation
import UIKit

protocol IndividualBusinessLogic: AnyObject {
    func fetchIndividualTracking()
}

class IndividualViewController: UIViewController, UITableViewDataSource {
    let loadingPrompt = Array(["Loading..."])
    let tableViewData = Array(["Loading..."])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTable.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        playersTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = self.tableViewData[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var playersTable: UITableView!
}
