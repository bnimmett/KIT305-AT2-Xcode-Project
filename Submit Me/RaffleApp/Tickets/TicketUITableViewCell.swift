//
//  TicketTableViewCell.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 15/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

protocol ShareTicketProtocol {
    func shareTicketInfo(_ customerName: String, _ customerTicketNum: String, _ customerSoldTime: String)
}

class TicketUITableViewCell: UITableViewCell {

    var delegate: ShareTicketProtocol!
    
    @IBOutlet var ticketCustomerNameLabel: UILabel!
    @IBOutlet var ticketSoldLabel: UILabel!
    @IBOutlet var ticketNumberLabel: UILabel!
    @IBAction func shareTicketInformation(_ sender: Any) {
        self.delegate.shareTicketInfo(ticketCustomerNameLabel.text!, ticketNumberLabel.text!, ticketSoldLabel.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
