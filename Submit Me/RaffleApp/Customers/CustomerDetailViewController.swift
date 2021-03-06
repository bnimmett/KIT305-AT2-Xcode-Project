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
    
   private func emptyAlert() //REF[3]
   {
       let emptyAlertController = UIAlertController(title: "Empty Values", message:"All fields must contain a value", preferredStyle: UIAlertController.Style.alert)
       
       let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
       emptyAlertController.addAction(dismissAction)
    
       present(emptyAlertController, animated: true, completion: nil)
   }
     
    private func deleteAlert() //REF[3]
    {
        let deleteAlertController = UIAlertController(title: "Delete?", message:"You cannot undo this action", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { _ in
            
        }
        let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive) { _ in
            self.deleteCustomer()
        }
         
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(deleteAction)
        
        present(deleteAlertController, animated: true, completion: nil)
    }
    
    @IBAction func SaveCustomerButtontap(_ sender: UIButton) {

        var empty = false
        
        if(customerNameField.text == "" || customerEmailField.text == "" || CustomerPhoneField.text == "" || CustomerPostcodeField.text == "")
        {
            empty = true
            emptyAlert()
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
    
    @IBAction func deleteCustomerButtontap(_ sender: UIButton)
    {
        deleteAlert()
    }
    
    private func deleteCustomer()
    {
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
    
    func addToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //toolbar with button for all regular textfield keyboards
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        //set button on right
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
    
        //add each toolbar to keyboard
        customerNameField.inputAccessoryView = toolbar
        customerEmailField.inputAccessoryView = toolbar
        CustomerPhoneField.inputAccessoryView = toolbar
        CustomerPostcodeField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonPressed()
    {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addToolbar()

        if let  displayCustomer = customer
        {
            customerNameField.text = displayCustomer.customer_name
            customerEmailField.text = displayCustomer.email
            CustomerPhoneField.text = String(displayCustomer.phone)
            CustomerPostcodeField.text = String(displayCustomer.postcode)
            print("Recieved customer \(displayCustomer.customer_id)")
            print("Archived: \(String(displayCustomer.archived))")
            
            print(displayCustomer.customer_id)
        }
        else {
            print("Didnt recieve cutomer from segue")
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}
