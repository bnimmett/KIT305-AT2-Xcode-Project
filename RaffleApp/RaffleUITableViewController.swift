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
        
        database.insert(raffle:Raffle(
            name:"Tuesday night raffle",
            draw_date:"2020-05-05 00:00:00.000",
            prize:5000,
            pool:150,
            max:5,
            recuring:false)
        )
        
        database.insert(raffle:Raffle(
            name:"Wednesday night raffle",
            draw_date:"2020-05-06 00:00:00.000",
            prize:10000,
            pool:450,
            max:15,
            recuring:true)
        )
        
        database.insert(raffle:Raffle(
            name:"Thursday night raffle",
            draw_date:"2020-05-07 00:00:00.000",
            prize:2500,
            pool:75,
            max:10,
            recuring:false)
        )
        raffles = database.selectAllRaffles()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return raffles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RaffleUITableViewCell", for: indexPath)

        let raffle = raffles[indexPath.row]
        
        if let raffleCell = cell as? RaffleUITableViewCell
        {
            raffleCell.titleLabel.text = raffle.name
            raffleCell.subTitleLabel.text = String(raffle.draw_date.prefix(10))
        }
        
        
        return cell
    }
    

    override func   prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowRaffleDetailSegue"
        {
            guard let detailViewController = segue.destination as? DetailViewController else
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
