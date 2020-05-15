//
//  MovieUITableViewController.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleUITableViewController: UITableViewController {
    
    var raffles = [Raffle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        raffles = database.selectAllActiveRaffles()
    }

    //Reloads Raffle list when view appears
    override func viewWillAppear(_ animated: Bool) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        raffles = database.selectAllActiveRaffles()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raffles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RaffleUITableViewCell", for: indexPath)

        let raffle = raffles[indexPath.row]
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        let ticket_count = database.selectTicketCountByRaffle(raffle_id:raffle.raffle_id)
        
        if let raffleCell = cell as? RaffleUITableViewCell
        {
            raffleCell.raffle_name_label.text = raffle.raffle_name
            raffleCell.raffle_draw_date_label.text = String(raffle.draw_date.prefix(10))
            raffleCell.raffle_prize_label.text = String(raffle.prize)
            raffleCell.raffle_sold_label.text = String(ticket_count)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowRaffleDetailSegue"
        {
            guard let detailViewController = segue.destination as? RaffleDetailViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedRaffleCell = sender as? RaffleUITableViewCell else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedRaffleCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRaffle = raffles[indexPath.row]
            detailViewController.raffle = selectedRaffle
        }
    }

}
