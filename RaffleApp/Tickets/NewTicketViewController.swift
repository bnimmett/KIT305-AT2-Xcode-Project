//
//  SellTicketsViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 14/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class NewTicketViewController: UIViewController {
    
    var raffle : Raffle?
    
    @IBOutlet var raffleTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let displayRaffle = raffle
        {
            raffleTitle.text = displayRaffle.raffle_name
        }
    }
    

}
