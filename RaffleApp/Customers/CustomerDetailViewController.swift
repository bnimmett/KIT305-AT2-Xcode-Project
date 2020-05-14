//
//  CustomerDetailViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 14/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class CustomerDetailViewController: UIViewController {

    var customer : Customer?
        
    @IBOutlet var   customerNameField: UITextField!
    @IBOutlet var   customerEmailField: UITextField!
    @IBOutlet var   CustomerPhoneField: UITextField!
    @IBOutlet var   CustomerPostcodeField: UITextField!
    
    @IBAction func SaveCustomerButtontap(_ sender: UIButton) {

        var empty = false
        
        if(customerNameField.text == "" || customerEmailField.text == "" || CustomerPhoneField.text == "" || CustomerPostcodeField.text == "")
        {
            empty = true
            print("All fields must have values")
            // Add alert message
        }
                
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
            let updateCustomer = Customer(
                customer_id: customer?.customer_id ?? -1,
                customer_name:customerNameField.text!,
                email:customerEmailField.text!,
                phone:Int32(CustomerPhoneField.text!) ?? 0,
                postcode:Int32(CustomerPostcodeField.text!) ?? 0,
                archived:false
            )
            if updateCustomer.customer_id == -1 {
                print("Error Customer not updated")
                //add alert
                self.navigationController!.popViewController(animated: true)

            }
            else {
                database.update(customer:updateCustomer)
                print("Customer \(customer?.customer_id ?? -2) updated")
                self.navigationController!.popViewController(animated: true)

            }
        }
    }
    
    @IBAction func deleteCustomerButtontap(_ sender: UIButton) {
        //Note this will save any changes made to the user. Perhaps implement a new archive database function.
        //Add alert for confirmation
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        let updateCustomer = Customer(
            customer_id: customer?.customer_id ?? -1,
            customer_name:customerNameField.text!,
            email:customerEmailField.text!,
            phone:Int32(CustomerPhoneField.text!) ?? 0,
            postcode:Int32(CustomerPostcodeField.text!) ?? 0,
            archived:true
            )
        if updateCustomer.customer_id == -1 {
            print("error deleting cutomer")
            //Add alert
            self.navigationController!.popViewController(animated: true)
        }
        else{
            database.update(customer:updateCustomer)
            print("\(updateCustomer.customer_id) \(updateCustomer.customer_name) \(updateCustomer.email) \(updateCustomer.postcode) \(updateCustomer.phone) \(updateCustomer.archived)")
            print("Customer \(updateCustomer.customer_id) deleted")
                //sends user to previous view controller
                self.navigationController!.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerNameField.returnKeyType = UIReturnKeyType.done
        customerEmailField.returnKeyType = UIReturnKeyType.done
        CustomerPhoneField.returnKeyType = UIReturnKeyType.done
        CustomerPostcodeField.returnKeyType = UIReturnKeyType.done

        if let  displayCustomer = customer
        {
            customerNameField.text = displayCustomer.customer_name
            customerEmailField.text = displayCustomer.email
            CustomerPhoneField.text = String(displayCustomer.phone)
            CustomerPostcodeField.text = String(displayCustomer.postcode)
            print("Recieved customer \(displayCustomer.customer_id)")
            print("Archived: \(String(displayCustomer.archived))")
        }
        else {
            print("Didnt recieve cutomer from segue")
        }
    }

}
