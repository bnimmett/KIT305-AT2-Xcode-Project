//
//  SellTicketsViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 14/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class NewTicketViewController: UIViewController, PassCustomerProtocol {
    
    
    var raffle : Raffle?
    var customer : Customer? {
        didSet{
            customerName.text = customer?.customer_name ?? "No Customer Selected"
        }
    }

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
    
    func passCustomer(_ sentCustomer: Customer) {
        customer = sentCustomer
        print("customer selected")
    }
    
    //Shows VC over the top of current VC rather than new page REF[5]
    @IBAction func customerButtonTapped(_ sender: UIButton) {
        
        let customerPopOver = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customerPopOver") as! CustomerPopOverViewController
        customerPopOver.delegateTwo = self
        //customerPopOver.raffle = raffle
        self.addChild(customerPopOver)
        //customerPopOver.view.self.subviews[1].
        customerPopOver.view.frame = self.view.frame
        self.view.addSubview(customerPopOver.view)
        customerPopOver.didMove(toParent: self)
    }
    
    @IBAction func buyTicketsButtonTapped(_ sender: UIButton) {
        
        if raffleBuyQuantity.text != "" || totalPrice.text != "0"
        {
            let database :SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")
            
            //var raffles = [Raffle]()
            //var customers = [Customer]()
            var ticketsPerRaffle = [Ticket]()
            //var raffleId: Int32 = 9999
            let raffleId = raffle?.raffle_id ?? 9999
            //var customerId: Int32 = 9999
            let customerId = customer?.customer_id ?? 9999
            var ticketCount: Int32 = -1
            
            ticketsPerRaffle = database.selectTicketsByRaffle(raffle_id: raffleId)
            ticketCount = Int32(ticketsPerRaffle.count)
            
            //raffles = database.selectAllActiveRaffles()
            //customers = database.selectAllCustomers()
            
            
            //Cycle through each table in database searching for matching raffle and ticket
/*            for raffles in raffles
            {
                if raffles.raffle_name == raffleTitle.text
                {
                    raffleId = raffles.raffle_id
                    ticketsPerRaffle = database.selectTicketsByRaffle(raffle_id: raffleId)
                    ticketCount = Int32(ticketsPerRaffle.count)
                }
            }
            for customers in customers
            {
                if customers.customer_name == customerName.text
                {
                    customerId = customers.customer_id
                }
            }
  */
            if raffleId != 9999 && customerId != 9999 && ticketCount != -1
            {
                var count:Int = Int(raffleBuyQuantity.text ?? "0") ?? 0
                while count != 0 {
                    count -= 1

                    //Update raffle current
                    let ticket_count = database.selectTicketCountByRaffle(raffle_id: raffle?.raffle_id ?? 0)
                    database.update(raffle: Raffle(
                        raffle_id: raffle!.raffle_id,
                        raffle_name: raffle!.raffle_name,
                        draw_date: raffle!.draw_date,
                        start_date: raffle!.start_date,
                        price: raffle!.price,
                        prize: raffle!.prize,
                        max: raffle!.max,
                        current: ticket_count+1,
                        //current: raffle!.current+1,
                        recuring: raffle!.recuring,
                        frequency: raffle!.frequency,
                        archived: raffle!.archived,
                        image: raffle!.image))
                    
                    database.insert(ticket: Ticket(
                        raffle_id: raffleId,
                        customer_id: customerId,
                        number: ticketCount + 1,
                        archived: false))
                    ticketCount += 1
                }
                
                //self.navigationController!.popViewController(animated: true)
            }
        } else {
            alert(Title: "No Tickets Selected", Message: "")
        }
    }
    
    private func alert(Title:String, Message:String) //REF[3]
    {
        let emptyAlertController = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        emptyAlertController.addAction(dismissAction)
     
        present(emptyAlertController, animated: true, completion: nil)
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
            let formatted = String(format: "%.2f", totalP) //REF[1]
            totalPrice.text = String(formatted)
        }
     
        if raffleBuyQuantity.text == ""
        {
            totalPrice.text = "0"
        }
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerName.text = customer?.customer_name ?? "No Customer Selected"
        totalPrice.text = "0"
        dollarSignLabel.text = "$"
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ReturnToRaffleDetailSegue"
        {
            guard let RaffleDetailViewController = segue.destination as? RaffleDetailViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let buyButton = sender as? UIButton else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            RaffleDetailViewController.raffle = raffle
        }
    }
}



