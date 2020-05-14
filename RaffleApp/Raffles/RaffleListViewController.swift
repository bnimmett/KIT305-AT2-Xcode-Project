//
//  HomepageViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 11/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        //uncomment and run to treload database
        //database.insertPlaceholders()
    }
}
