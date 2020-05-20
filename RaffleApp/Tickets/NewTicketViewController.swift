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
    
    var localPrice = 0.0
    
    @IBOutlet var raffleTitle: UILabel!
    @IBOutlet var raffleDrawDate: UILabel!
    @IBOutlet var raffleStartDate: UILabel!
    @IBOutlet var rafflePrize: UILabel!
    @IBOutlet var rafflePrice: UILabel!
    @IBOutlet var raffleSold: UILabel!
    @IBOutlet var raffleMax: UILabel!
    @IBOutlet var raffleBuyTotal: UILabel!
    
    @IBOutlet var customerName: UILabel!
    

    @IBOutlet var raffleBuyQuantity: UITextField!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var dollarSignLabel: UILabel!
    
    
    //Shows VC over the top of current VC rather than new page
    @IBAction func customerButtonTapped(_ sender: UIButton) {
        
        let customerPopOver = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customerPopOver") as! CustomerPopOverViewController
        self.addChild(customerPopOver)
        customerPopOver.view.frame = self.view.frame
        self.view.addSubview(customerPopOver.view)
        customerPopOver.didMove(toParent: self)
    }
    
    
    
    
    @IBAction func buyTicketsButtonTapped(_ sender: UIButton) {
        
        /* Search for customer in database == textfield
         * Insert tickets
         * Update raffle
        */
    }
    
    func addToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
     
        //toolbar with button for all regular textfield keyboards
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        //set button on right
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        //add toolbar to keyboard
        raffleBuyQuantity.inputAccessoryView = toolbar
    }
    
    /*
     Calculate total price and display on screen
     */
    @objc func doneButtonPressed()
    {
        if let buyQuantity = Double(raffleBuyQuantity.text!)
        {
            let totalP = buyQuantity * localPrice
            //Display Double as String with two decimal places
            let formatted = String(format: "%.2f", totalP)
            totalPrice.text = String(formatted)
            dollarSignLabel.text = "$"

        }
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerName.text = ""
        totalPrice.text = ""
        dollarSignLabel.text = ""
        
        addToolbar()
        
        if let displayRaffle = raffle
        {
            raffleTitle.text = displayRaffle.raffle_name
            raffleDrawDate.text = String(displayRaffle.draw_date.prefix(10))
            rafflePrize.text = String(displayRaffle.prize)
            rafflePrice.text = String(displayRaffle.price)
            raffleSold.text = String(displayRaffle.current)
            raffleMax.text = String(displayRaffle.max)
            
            localPrice = displayRaffle.price
            
            
        }
        
        /*
         * Code to close keyboard by selecting anywhere on the screen
         * Source: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    

}
