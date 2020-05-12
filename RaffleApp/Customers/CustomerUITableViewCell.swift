//
//  CustomerUITableViewCell.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 11/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class CustomerUITableViewCell: UITableViewCell {

    @IBOutlet var customer_name_label: UILabel!
    @IBOutlet var customer_phone_label: UILabel!
    @IBOutlet var customer_email_label: UILabel!
    @IBOutlet var customer_postcode_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
