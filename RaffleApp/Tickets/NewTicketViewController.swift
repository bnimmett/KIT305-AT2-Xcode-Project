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
    @IBOutlet var raffleDrawDate: UILabel!
    @IBOutlet var raffleStartDate: UILabel!
    @IBOutlet var rafflePrize: UILabel!
    @IBOutlet var rafflePrice: UILabel!
    @IBOutlet var raffleSold: UILabel!
    @IBOutlet var raffleMax: UILabel!
    @IBOutlet var raffleBuyTotal: UILabel!
    
    
    @IBOutlet var customerName: UITextField!
    @IBOutlet var raffleBuyQuantity: UITextField!
    
    
    @IBAction func buyTicketsButtonTapped(_ sender: UIButton) {
        
        /* Search for customer in database == textfield
         * Insert tickets
         * Update raffle
        */
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let displayRaffle = raffle
        {
            raffleTitle.text = displayRaffle.raffle_name
            raffleDrawDate.text = String(displayRaffle.draw_date.prefix(10))
            rafflePrize.text = String(displayRaffle.prize)
            rafflePrice.text = String(displayRaffle.price)
            raffleSold.text = String(displayRaffle.current)
            raffleMax.text = String(displayRaffle.max)
            
          
            
            
        }
        
        /*
         * Code to close keyboard by selecting anywhere on the screen
         * Source: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    

}
