//
//  TicketTableViewCell.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 15/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class TicketUITableViewCell: UITableViewCell {

    @IBOutlet var ticketCustomerNameLabel: UILabel!
    @IBOutlet var ticketSoldLabel: UILabel!
    @IBOutlet var ticketNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
