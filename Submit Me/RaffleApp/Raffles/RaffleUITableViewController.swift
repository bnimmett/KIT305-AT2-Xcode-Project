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
    var showingEndedRaffles:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        if showingEndedRaffles {
            raffles = database.selectAllInactiveRaffles()
        }
        else {
            raffles = database.selectAllActiveRaffles()
        }
    }

    //Reloads Raffle list when view appears
    override func viewWillAppear(_ animated: Bool) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        if showingEndedRaffles {
            raffles = database.selectAllInactiveRaffles()
        }
        else {
            raffles = database.selectAllActiveRaffles()
        }
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
                
        if let raffleCell = cell as? RaffleUITableViewCell
        {
            let drawDate = raffle.draw_date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS.000"
            
            let textDrawDate = dateFormatter.date(from: drawDate)
            
            dateFormatter.dateFormat = "d MMM YYYY"
              
            raffleCell.raffleNameLabel.text = raffle.raffle_name
            raffleCell.raffleDrawDateLabel.text = dateFormatter.string(from: textDrawDate!)
            raffleCell.rafflePrizeLabel.text = String(raffle.prize)
            raffleCell.raffleTicketsSoldLabel.text = String(raffle.current)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowRaffleDetailSegue"
        {
            guard let RaffleDetailViewController = segue.destination as? RaffleDetailViewController else
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
            RaffleDetailViewController.raffle = selectedRaffle
        }
    }
}
