//
//  HomepageViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 11/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleListViewController: UIViewController {

    var insert = false
    var raffles = [Raffle]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
       
        raffles = database.selectAllRaffles()
        
        if insert {
            database.insert(raffle:Raffle(
                raffle_name:"Tuesday night raffle",
                draw_date:"2020-05-12 00:00:00.000",
                price:1.5,
                prize:5000,
                pool:150,
                max:5,
                recuring:true,
                frequency:"Weekly",
                archived:false,
                image:"")
            )
            
            database.insert(raffle:Raffle(
                raffle_name:"Wacky Wednesday",
                draw_date:"2020-05-13 00:00:00.000",
                price:3,
                prize:10000,
                pool:75,
                max:3,
                recuring:false,
                frequency:"",
                archived:false,
                image:"")
            )
            
            database.insert(raffle:Raffle(
                raffle_name:"First Friday Frenzy",
                draw_date:"2020-05-15 00:00:00.000",
                price:0.5,
                prize:2500,
                pool:500,
                max:10,
                recuring:true,
                frequency:"Monthly",
                archived:false,
                image:"")
            )
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           super.prepare(for: segue, sender: sender)
           
           if (segue.identifier == "ShowRaffleTableSegue")
           {
            guard let RaffleUITableViewController = segue.destination as? RaffleUITableViewController else
               {
                   fatalError("Unexpected destination: \(segue.destination)")
               }
               
               //RaffleUITableViewController.raffles = raffles
           }
       }

}
