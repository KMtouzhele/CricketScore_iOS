//
//  PlayerViewCell.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/9.
//

import UIKit
class PlayerViewCell: UITableViewCell {
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerId: UILabel!
    @IBOutlet weak var teamType: UILabel!
    @IBOutlet weak var playerStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
