//
//  TodaySummaryCell.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/13/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class TodaySummaryCell: UITableViewCell {

    @IBOutlet weak var calories: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
