//
//  TicketUITableViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 15/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class TicketUITableViewController: UITableViewController, ShareTicketProtocol {
    
    var raffle : Raffle?
    var tickets = [Ticket]()
    func shareTicketInfo(_ customerName: String, _ customerTicketNum: String, _ customerSoldTime: String) {
            let shareViewController = UIActivityViewController(
                activityItems: ["\(customerName)'s ticket number \(customerTicketNum) sold at \(customerSoldTime) for \(raffle!.raffle_name) which will be drawn on \(raffle!.draw_date). The prize is $ \(raffle!.prize)"], applicationActivities: [])
        present(shareViewController, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        print("Loading Tickets")
        if let raffle_id = raffle?.raffle_id {
            tickets = database.selectTicketsByRaffle(raffle_id: raffle_id)
            print("Tickets Loaded, for raffle \(raffle_id)")
        }
        else{
            print("Tickets not Loaded, for raffle \(raffle?.raffle_id ?? -1)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        if let raffle_id = raffle?.raffle_id {
            tickets = database.selectTicketsByRaffle(raffle_id: raffle_id)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketUITableViewCell", for: indexPath)
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")

        let ticket = tickets[indexPath.row]
        let customer = database.selectCustomerByID(customer_id: ticket.customer_id)
        
        if let ticketCell = cell as? TicketUITableViewCell
        {
           
            let soldTime = ticket.sold
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            
            let time = dateFormatter.date(from: soldTime)
            dateFormatter.dateFormat = "MMM d, h:mm a"
            
            ticketCell.ticketCustomerNameLabel.text = customer.customer_name
            ticketCell.ticketSoldLabel.text = dateFormatter.string(from: time!)
            ticketCell.ticketNumberLabel.text = String(ticket.number)
            ticketCell.delegate = self
        }
                
        return cell
    }

}
