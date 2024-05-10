//
//  MatchHistoryCell.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import UIKit

class MatchHistoryCell: UITableViewCell {

    @IBOutlet weak var battingTeamName: UILabel!
    @IBOutlet weak var bowlingTeamName: UILabel!
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var totalRuns: UILabel!
    
    var matchId = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
