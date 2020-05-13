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
    
    
    var empty = false
    
    @IBAction func saveCustomerButtonTapped(_ sender: UIButton) {

        if(customerNameField.text == "" || customerEmailField.text == "" || customerPhoneField.text == "" || customerPostcodeField.text == "")
        {
            empty = true
            // Add alert message
        }
                
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")

            database.insert(customer:Customer(
                customer_name:customerNameField.text!,
                email:customerEmailField.text!,
                phone:Int32(customerPhoneField.text!) ?? 0,
                postcode:Int32(customerPostcodeField.text!) ?? 0
                )
            )
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}