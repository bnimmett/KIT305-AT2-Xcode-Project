//
//  WinningTicketTableViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 22/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class WinningTicketTableViewController: UITableViewController {
        
    var raffle : Raffle?
    var tickets = [Ticket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        if let raffle_id = raffle?.raffle_id {
            tickets = database.selectWinningTicketsByRaffle(raffle_id: raffle_id)
            print("Tickets Loaded, for raffle \(raffle_id)")
        }
        else{
            print("Tickets not Loaded, for raffle \(raffle?.raffle_id ?? -1)")
        }
    }
    
    func reloadTable() {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        if let raffle_id = raffle?.raffle_id {
            tickets = database.selectWinningTicketsByRaffle(raffle_id: raffle_id)
        }
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinningTicketTableViewCell", for: indexPath)
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")

        let ticket = tickets[indexPath.row]
        let customer = database.selectCustomerByID(customer_id: ticket.customer_id)
        
        if let ticketCell = cell as? WinningTicketTableViewCell
        {
            ticketCell.ticketCustomerNameLabel.text = customer.customer_name
            ticketCell.ticketWinLabel.text = String(ticket.win)
            ticketCell.ticketNumberLabel.text = String(ticket.number)
        }
        
        return cell
    }

}
