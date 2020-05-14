//
//  NewCustomerViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 13/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class NewCustomerViewController: UIViewController {
        
    @IBOutlet var customerNameField: UITextField!
    @IBOutlet var customerEmailField: UITextField!
    @IBOutlet var customerPhoneField: UITextField!
    @IBOutlet var customerPostcodeField: UITextField!
        
    @IBAction func saveCustomerButtonTapped(_ sender: UIButton) {

        /*
         * Note: Moved emtpy var inside to function to fix case when user presses
         * Save customer button with an empty field and therefore empty is set to true.
         * User then completes empty fields and presses button a second time,
         * however emtpy is always set to true, making nothing happen.
         * By making empty a local variable it is set to false at the start of each press.
         * Alternatively could have just assigned empty to false instead at each function call.
         */
        var empty = false
        
        if(customerNameField.text == "" || customerEmailField.text == "" || customerPhoneField.text == "" || customerPostcodeField.text == "")
        {
            empty = true
            print("All fields must have values")
            // Add alert message
        }
                
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")

            database.insert(customer:Customer(
                customer_id: -1,
                customer_name:customerNameField.text!,
                email:customerEmailField.text!,
                phone:Int32(customerPhoneField.text!) ?? 0,
                postcode:Int32(customerPostcodeField.text!) ?? 0,
                archived:false
                )
            )
            
            //sends user to previous view controller
            self.navigationController!.popViewController(animated: true)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerNameField.returnKeyType = UIReturnKeyType.done
        customerEmailField.returnKeyType = UIReturnKeyType.done
        customerPhoneField.returnKeyType = UIReturnKeyType.done
        customerPostcodeField.returnKeyType = UIReturnKeyType.done
        
        /*
         * Code to close keyboard by selecting anywhere on the screen
         * Source: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
