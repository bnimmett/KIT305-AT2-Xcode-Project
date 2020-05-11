//
//  CustomerUITableViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 11/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class CustomerUITableViewController: UITableViewController {

    var customers = [Customer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        customers = database.selectAllCustomers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerUITableViewCell", for: indexPath)

        let customer = customers[indexPath.row]
        
        if let customerCell = cell as? CustomerUITableViewCell
             {
                customerCell.customer_name_label.text = customer.customer_name
                customerCell.customer_email_label.text = customer.email
                customerCell.customer_phone_label.text = String(customer.phone)
                customerCell.customer_postcode_label.text = String(customer.postcode)
             }
        
        return cell
    }

}
