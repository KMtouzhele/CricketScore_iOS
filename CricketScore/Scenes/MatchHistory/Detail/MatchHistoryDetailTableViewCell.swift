//
//  MatchHistoryDetailTableViewCell.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/10.
//

import UIKit

class MatchHistoryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var strikerName: UILabel!
    @IBOutlet weak var nonStrikerName: UILabel!
    @IBOutlet weak var bowlerName: UILabel!
    @IBOutlet weak var result: UILabel!
    
    var ballId = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
