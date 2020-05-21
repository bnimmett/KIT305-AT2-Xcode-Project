//
//  DetailViewController.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleDetailViewController: UIViewController {

    var raffle : Raffle?
    
    @IBOutlet var   raffleName: UILabel!
    @IBOutlet var   raffleDrawDate: UILabel!
    @IBOutlet var   rafflePrize: UILabel!
    @IBOutlet var   raffleSold: UILabel!
    @IBOutlet var   raffleMax: UILabel!
    @IBOutlet var   rafflePrice: UILabel!
    
    
    
    @IBOutlet var   sellTicketButton: UIButton!
    @IBOutlet var   drawWinnerButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let  displayRaffle = raffle
        {
            raffleName.text = displayRaffle.raffle_name
            raffleDrawDate.text = String(displayRaffle.draw_date.prefix(10))
            rafflePrize.text = String(displayRaffle.prize)
            rafflePrice.text = String(displayRaffle.price)
            raffleMax.text = String(displayRaffle.max)
            
            print(displayRaffle.raffle_id)
            
            //When backbutton is pressed, will always return to raffle list and not new ticket view.
            if let returnToRoot = navigationController?.viewControllers.first {
                navigationController?.viewControllers = [returnToRoot, self]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        raffleSold.text = String(database.selectTicketCountByRaffle(raffle_id: raffle!.raffle_id))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "EditRaffleSegue"
        {
            guard let EditRaffleViewController = segue.destination as? EditRaffleViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let editButton = sender as? UIBarItem else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            EditRaffleViewController.raffle = raffle
        }
        
        if segue.identifier == "ShowNewTicketSegue"
        {
            guard let NewTicketViewController = segue.destination as? NewTicketViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let currentRaffle = sender as? UIButton else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            NewTicketViewController.raffle = raffle
        }
    
        if segue.identifier == "ShowTicketTableSegue"
        {
            guard let TicketUITableViewController = segue.destination as? TicketUITableViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let RaffleDetailViewController = sender as? RaffleDetailViewController else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            TicketUITableViewController.raffle = raffle
        }
    }
}
