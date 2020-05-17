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
        
    
    private func emptyAlert()
       {
           let emptyAlertController = UIAlertController(title: "Empty Values", message:"All fields must contain a value", preferredStyle: UIAlertController.Style.alert)
           
           let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
           emptyAlertController.addAction(dismissAction)
        
           present(emptyAlertController, animated: true, completion: nil)
       }
    
    
    @IBAction func saveCustomerButtonTapped(_ sender: UIButton) {

        
        var empty = false
        
        if(customerNameField.text == "" || customerEmailField.text == "" || customerPhoneField.text == "" || customerPostcodeField.text == "")
        {
            empty = true
            emptyAlert()
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
