//
//  MovieUITableViewCell.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleUITableViewCell: UITableViewCell {

    @IBOutlet var raffle_name_label: UILabel!
    @IBOutlet var raffle_draw_date_label: UILabel!
    @IBOutlet var raffle_prize_label: UILabel!
    @IBOutlet var raffle_sold_label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
