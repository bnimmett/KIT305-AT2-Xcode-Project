//
//  DrawTicketViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 22/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class DrawTicketViewController: UIViewController {

    var raffle: Raffle?
    var tickets = [Ticket]()
    var numWinners: Int32?
    
    @IBOutlet var inputMarginTextField: UITextField!
    
    
    @IBAction func drawRandomButton(_ sender: UIButton) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        var winner = tickets.randomElement()
        winner?.win = (numWinners ?? 0) + 1
        database.update(ticket: winner ?? Ticket(
            raffle_id: -1,
            customer_id: -1,
            number: 0,
            win: 0))
    }
    
    @IBAction func drawMarginButton(_ sender: Any) {
        if inputMarginTextField.text != "" {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        print("Loading Tickets")
        if let raffle_id = raffle?.raffle_id {
            tickets = database.selectTicketsByRaffle(raffle_id: raffle_id)
            numWinners = database.selectWinningTicketCountByRaffle(raffle_id: raffle_id)
            print("Tickets Loaded, for raffle \(raffle_id)")
        }
        else{
            print("Tickets not Loaded, for raffle \(raffle?.raffle_id ?? -1)")
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowWinningTicketTable"
        {
            guard let WinningTicketTableViewController = segue.destination as? WinningTicketTableViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let DrawTicketViewController = sender as? DrawTicketViewController else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            WinningTicketTableViewController.raffle = raffle
        }
    }
    

}
