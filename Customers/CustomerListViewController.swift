//
//  CustomerListViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 11/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class CustomerListViewController: UIViewController {

    var insert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")

            if insert {
                database.truncateTable(tableName:"customer")
                
                database.insert(customer:Customer(
                    customer_name:"Brandon Nimmett",
                    email:"bnimmett@utas.fake.au",
                    phone:123456789,
                    postcode:7000
                   )
                )
                
                database.insert(customer:Customer(
                    customer_name:"Smithy Smithson",
                    email:"Ssmmiitthhyy@utas.fake.au",
                    phone:987654321,
                    postcode:7250
                   )
                )
                
                database.insert(customer:Customer(
                    customer_name:"Billy Bob",
                    email:"bb8@utas.fake.au",
                    phone:96664440,
                    postcode:7270
                   )
                )
            }
        }
}
