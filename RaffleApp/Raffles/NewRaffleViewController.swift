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
    @IBOutlet var raffleDescriptionField: UITextField!
    @IBOutlet var marginSwitch: UISwitch!

    let drawDatePicker = UIDatePicker()
    let startDatePicker = UIDatePicker()
    
    @IBAction func SaveRaffleButtonTapped(_ sender: UIButton) {
        
        var empty = false
        
        if(raffleNameField.text == "" || raffleDescriptionField.text == "" || rafflePriceField.text == "" || raffleMaxTicketField.text == "" || rafflePrizeField.text == "" || raffleDrawDateField.text == "" || raffleStartDateField.text == "")
        {
            empty = true
            emptyAlert()
        }
        
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
            
            database.insert(raffle:Raffle(
                raffle_name:raffleNameField.text!,
                raffle_description:raffleDescriptionField.text!,
                draw_date:raffleDrawDateField.text!,
                start_date:raffleStartDateField.text!,
                price:Double(rafflePriceField.text!) ?? 0,
                prize:Int32(rafflePrizeField.text!) ?? 0,
                max:Int32(raffleMaxTicketField.text!) ?? 0, 
                current:0,
                margin:marginSwitch.isOn,
                archived:false)
            )
            
            //sends user to previous view controller
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    /*
     Function to add a toolbar and 'done' button to close keyboards on textfields
     */
    func addToolbar()
    {
        let toolbar = UIToolbar()
        let toolbarDraw = UIToolbar()
        let toolbarStart = UIToolbar()
        toolbar.sizeToFit()
        toolbarDraw.sizeToFit()
        toolbarStart.sizeToFit()
     
        //toolbar with button for all regular textfield keyboards
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        //set button on right
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        
        //seperate toolbar with done button for each date textfield keyboard
        let doneButtonDraw = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressDraw))
        //set button on right
        let flexSpaceDraw = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        toolbarDraw.setItems([flexSpaceDraw, doneButtonDraw], animated: true)
        
        let doneButtonStart = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressStart))
        //set button on right
        let flexSpaceStart = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        toolbarStart.setItems([flexSpaceStart, doneButtonStart], animated: true)
        
        //add each toolbar to keyboard
        raffleNameField.inputAccessoryView = toolbar
        rafflePriceField.inputAccessoryView = toolbar
        rafflePrizeField.inputAccessoryView = toolbar
        raffleMaxTicketField.inputAccessoryView = toolbar
        raffleDescriptionField.inputAccessoryView = toolbar
        raffleDrawDateField.inputAccessoryView = toolbarDraw
        raffleStartDateField.inputAccessoryView = toolbarStart
    }
    
    /*
     Function that adds date picker keyboard to relevent textfields
     */
    func addDatePicker()
    {
        raffleDrawDateField.inputView = drawDatePicker
        raffleStartDateField.inputView = startDatePicker
        
        //date picker style
        drawDatePicker.datePickerMode = .dateAndTime
    }
    
    @objc func doneButtonPressed()
    {
        self.view.endEditing(true)
    }
    
    //https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter

    
    //Function to handle draw date toolbar button
    @objc func doneBtnPressDraw() {
        let drawDate = drawDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS.000"
        raffleDrawDateField.text = (dateFormatter.string(from: drawDate))
        self.view.endEditing(true)
    }
    //Function to handle start date toolbar button
    @objc func doneBtnPressStart() {
       let startDate = startDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS.000"
        raffleStartDateField.text = (dateFormatter.string(from: startDate))
        self.view.endEditing(true)
    }
    
    
    private func emptyAlert()
    {
        let emptyAlertController = UIAlertController(title: "Empty Values", message:"All fields must contain a value", preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        emptyAlertController.addAction(dismissAction)
     
        present(emptyAlertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToolbar()
        addDatePicker()
        
        /*
         * Code to close keyboard by selecting anywhere on the screen
         * Source: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
