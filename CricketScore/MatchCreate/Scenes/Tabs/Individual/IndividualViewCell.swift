//
//  IndividualViewCell.swift
//  CricketScore
//
//  Created by Kilmer Li on 2024/5/8.
//

import UIKit
import Foundation

class IndividualViewCell: UITableViewCell {
    
    @IBOutlet weak var strikerName: UILabel!
    @IBOutlet weak var runs: UILabel!
    @IBOutlet weak var ballsFaced: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
