//
//  HomepageViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 11/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleListViewController: UIViewController {

    @objc func addTapped() {
        print("hi")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Older Raffles", style: .plain, target: self, action: #selector(addTapped))
        
        //uncomment and run to reload database
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        database.insertPlaceholders()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "ShowRaffleTableSegue"
        {
            guard let RaffleUITableViewController = segue.destination as? RaffleUITableViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            RaffleUITableViewController.showingEndedRaffles = true
            RaffleUITableViewController.title = "Ended Raffles"
        }
    }
}
