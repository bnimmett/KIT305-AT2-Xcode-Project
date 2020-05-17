//
//  NewRaffleViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 13/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class NewRaffleViewController: UIViewController {

    @IBOutlet var raffleNameField: UITextField!
    @IBOutlet var rafflePriceField: UITextField!
    @IBOutlet var raffleMaxTicketField: UITextField!
    @IBOutlet var rafflePrizeField: UITextField!
    @IBOutlet var raffleDrawDateField: UITextField!
    @IBOutlet var raffleStartDateField: UITextField!
    
    
    private func emptyAlert()
    {
        let emptyAlertController = UIAlertController(title: "Empty Values", message:"All fields must contain a value", preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        emptyAlertController.addAction(dismissAction)
     
        present(emptyAlertController, animated: true, completion: nil)
    }
    
    @IBAction func SaveRaffleButtonTapped(_ sender: UIButton) {
        
        var empty = false
        
        if(raffleNameField.text == "" || rafflePriceField.text == "" || raffleMaxTicketField.text == "" || rafflePrizeField.text == "" || raffleDrawDateField.text == "" || raffleStartDateField.text == "")
        {
            empty = true
            emptyAlert()
        }
        
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
            
            database.insert(raffle:Raffle(
                raffle_name:raffleNameField.text!,
                draw_date:raffleDrawDateField.text!,
                start_date:raffleStartDateField.text!,
                price:Double(rafflePriceField.text!) ?? 0,
                prize:Int32(rafflePrizeField.text!) ?? 0,
                pool:150,
                max:Int32(raffleMaxTicketField.text!) ?? 0,
                recuring:false,
                frequency:"Weekly",
                archived:false,
                image:"Test")
            )
            
            //sends user to previous view controller
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         * Code to close keyboard by selecting anywhere on the screen
         * Source: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
