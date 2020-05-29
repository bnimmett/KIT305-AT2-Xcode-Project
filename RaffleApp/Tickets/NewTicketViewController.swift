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
        self.addChild(customerPopOver)
        customerPopOver.view.frame = self.view.frame
        self.view.addSubview(customerPopOver.view)
        customerPopOver.didMove(toParent: self)
    }
    
    @IBAction func buyTicketsButtonTapped(_ sender: UIButton) {
        
        if raffleBuyQuantity.text != "" && totalPrice.text != "0" && customer != nil
        {
            let database :SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")

            let raffleId = raffle?.raffle_id ?? -1
            let customerId = customer?.customer_id ?? -1
            var ticket_count = database.selectTicketCountByRaffle(raffle_id: raffleId)

            if raffleId != -1 && customerId != -1 && ticket_count != -1
            {
                var count:Int = Int(raffleBuyQuantity.text ?? "0") ?? 0
                if Int32(count)+ticket_count <= raffle?.max ?? -1 {
                    while count != 0 {
                        count -= 1

                        //Update raffle current
                        ticket_count = database.selectTicketCountByRaffle(raffle_id: raffleId)
                        database.update(raffle: Raffle(
                            raffle_id: raffle!.raffle_id,
                            raffle_name: raffle!.raffle_name,
                            raffle_description: raffle!.raffle_description,
                            draw_date: raffle!.draw_date,
                            start_date: raffle!.start_date,
                            price: raffle!.price,
                            prize: raffle!.prize,
                            max: raffle!.max,
                            current: ticket_count+1,
                            margin: raffle!.margin,
                            archived: raffle!.archived))
                        
                        
                        if !raffle!.margin {
                            database.insert(ticket: Ticket(
                                raffle_id: raffleId,
                                customer_id: customerId,
                                number: ticket_count + 1,
                                win: 0))
                        }
                        else {
                            let max:Int32 = raffle?.max ?? 1
                            var allTickets = [Int32]()
                            for x in 0...max {
                                allTickets.append(x)
                            }
                            let soldTickets = database.selectSoldTicketNumbersByRaffle(raffle_id: raffleId)
                            let remainingTickets = Array(Set(allTickets).subtracting(soldTickets))
                            let randomNum = remainingTickets.randomElement()
                            database.insert(ticket: Ticket(
                                raffle_id: raffleId,
                                customer_id: customerId,
                                number: randomNum ?? -1,
                                win: 0))
                        }
                    }
                    raffleSold.text = String(raffle!.current)
                }
                else {
                    alert(Title: "Too many tickets", Message: "There are only \((raffle?.max ?? -1)-(raffle?.current ?? -1)) tickets remaining.")
                }
            }
        } else {
            alert(Title: "No Tickets or \nCustomer Selected", Message: "")
        }
        successAlert()
    }
    
    private func alert(Title:String, Message:String) //REF[3]
    {
        let emptyAlertController = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        emptyAlertController.addAction(dismissAction)
     
        present(emptyAlertController, animated: true, completion: nil)
    }
    
    private func successAlert() //REF[3]
    {
        let successAlert = UIAlertController(title: "Tickets Purchased Successfully", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default) { _ in
            self.successBuy()
        }
         
        successAlert.addAction(dismissAction)
        present(successAlert, animated: true, completion: nil)
    }
    
    private func successBuy()
    {
        self.navigationController!.popViewController(animated: true)
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

        
        addToolbar()
        
        if let displayRaffle = raffle
        {
            let formattedPrice = String(format: "%.2f", displayRaffle.price) //REF[1]
            let drawDate = displayRaffle.draw_date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS.000"
            let textDrawDate = dateFormatter.date(from: drawDate)
            dateFormatter.dateFormat = "dd/MM/YYYY, HH:mm"
            
            raffleTitle.text = displayRaffle.raffle_name
            raffleDrawDate.text = dateFormatter.string(from: textDrawDate!)
            rafflePrize.text = String(displayRaffle.prize)
            rafflePrice.text = formattedPrice
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



