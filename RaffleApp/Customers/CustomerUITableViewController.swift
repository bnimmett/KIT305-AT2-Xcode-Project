//
//  CustomerUITableViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 11/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

protocol SelectCustomerCellProtocol : class {
    func customerSelected(_ sentCustomer: Customer)
}

class CustomerUITableViewController: UITableViewController {
    
    weak var delegate: SelectCustomerCellProtocol?
    
    var customers = [Customer]()
    var raffle: Raffle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        customers = database.selectAllActiveCustomers()
    }
    
    //Reloads Customer list when view appears
    override func viewWillAppear(_ animated: Bool) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        customers = database.selectAllActiveCustomers()
        self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customers[indexPath.row]
        print("itsrunnung, selecting: ")
        print(customer.customer_name)
        delegate?.customerSelected(customer)
    }
    
    
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowCustomerDetailSegue"
        {
            guard let CustomerDetailViewController = segue.destination as? CustomerDetailViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCustomerCell = sender as? CustomerUITableViewCell else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCustomerCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            print("segueing")
            let selectedCustomer = customers[indexPath.row]
            CustomerDetailViewController.customer = selectedCustomer
        }

/* Old segue methof
        if segue.identifier == "SelectCustomerSellSegue"
        {
            guard let NewTicketViewController = segue.destination as? NewTicketViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCustomerCell = sender as? CustomerUITableViewCell else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCustomerCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCustomer = customers[indexPath.row]
            NewTicketViewController.customer = selectedCustomer
            NewTicketViewController.raffle = raffle
        }
 */
        
    }
}
