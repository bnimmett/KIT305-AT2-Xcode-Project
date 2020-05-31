//
//  MovieUITableViewCell.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleUITableViewCell: UITableViewCell {

    @IBOutlet var raffleNameLabel: UILabel!
    @IBOutlet var raffleDrawDateLabel: UILabel!
    @IBOutlet var rafflePrizeLabel: UILabel!
    @IBOutlet var raffleTicketsSoldLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
