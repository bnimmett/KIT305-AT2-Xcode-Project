//
//  EditRaffleViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 17/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class EditRaffleViewController: UIViewController {

    var raffle : Raffle?
    
    @IBOutlet var raffleNameField: UITextField!
    @IBOutlet var rafflePrice: UITextField!
    @IBOutlet var raffleMax: UITextField!
    @IBOutlet var rafflePrize: UITextField!
    @IBOutlet var raffleDrawDate: UITextField!
    @IBOutlet var raffleStartDate: UITextField!
    
    
    let drawDatePicker = UIDatePicker()
    let startDatePicker = UIDatePicker()
    
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        var empty = false
        
        if(raffleNameField.text == "" || rafflePrice.text == "" || rafflePrize.text == "" || raffleMax.text == "" || raffleDrawDate.text == "")
        {
            empty = true
            emptyAlert()
        }
        
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")
            let updateRaffle = Raffle(
                raffle_id: raffle?.raffle_id ?? -1,
                raffle_name:raffleNameField.text!,
                draw_date:raffleDrawDate.text!,
                start_date:raffle!.start_date,
                price:Double(rafflePrice.text!) ?? 0,
                prize:Int32(rafflePrize.text!) ?? 0,
                max:Int32(raffleMax.text!) ?? 0,
                current:raffle!.current,
                recuring:raffle!.recuring,
                frequency:raffle!.frequency,
                archived:false,
                image:raffle!.image
            )
            if updateRaffle.raffle_id == -1 {
                print("Error Raffle not updated")
                //add alert
                self.navigationController!.popViewController(animated: true)
            } else {
                database.update(raffle:updateRaffle)
                print("Raffle \(raffle?.raffle_id ?? -2) updated")
                self.navigationController!.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        deleteAlert()
    }
        
    private func deleteRaffle()
    {
        let database :SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")
        let updateRaffle = Raffle(
        raffle_id: raffle?.raffle_id ?? -1,
        raffle_name:raffle!.raffle_name,
        draw_date:raffle!.draw_date,
        start_date:raffle!.start_date,
        price:raffle!.price,
        prize:raffle!.prize,
        max:raffle!.max,
        current:raffle!.current,
        recuring:raffle!.recuring,
        frequency:raffle!.frequency,
        archived:true,
        image:raffle!.image
        )
        
        if updateRaffle.raffle_id == -1 {
            print("Error Raffle not updated")
            //add alert
            self.navigationController!.popViewController(animated: true)
        } else {
            database.update(raffle:updateRaffle)
            print("Raffle \(raffle?.raffle_id ?? -2) updated")
            self.navigationController!.popViewController(animated: true)
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    private func emptyAlert()
    {
        let emptyAlertController = UIAlertController(title: "Empty Values", message:"All fields must contain a value", preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        emptyAlertController.addAction(dismissAction)
     
        present(emptyAlertController, animated: true, completion: nil)
    }
    
    private func deleteAlert()
    {
        let deleteAlertController = UIAlertController(title: "Delete?", message:"You cannot undo this action", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { _ in
        }
        let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive) { _ in
            self.deleteRaffle()
        }
         
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(deleteAction)
        
        present(deleteAlertController, animated: true, completion: nil)
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
        rafflePrice.inputAccessoryView = toolbar
        rafflePrize.inputAccessoryView = toolbar
        raffleMax.inputAccessoryView = toolbar
        raffleDrawDate.inputAccessoryView = toolbarDraw
        raffleStartDate.inputAccessoryView = toolbarStart
    }
    
    /*
     Function that adds date picker keyboard to relevent textfields
     */
    func addDatePicker()
    {
        raffleDrawDate.inputView = drawDatePicker
        raffleStartDate.inputView = startDatePicker
        
        //date picker style
        drawDatePicker.datePickerMode = .dateAndTime
    }
    
    @objc func doneButtonPressed()
    {
        self.view.endEditing(true)
    }
    
    //https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
    //date picker text format to match database requirements */
    
    @objc func doneBtnPressDraw() {
        let drawDate = drawDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS.000"
        raffleDrawDate.text = (dateFormatter.string(from: drawDate))
        self.view.endEditing(true)
    }
    
    @objc func doneBtnPressStart() {
       let startDate = startDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS.000"
        raffleStartDate.text = (dateFormatter.string(from: startDate))
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToolbar()
        addDatePicker()
        
        if let displayRaffle = raffle
        {
            raffleNameField.text = displayRaffle.raffle_name
            rafflePrice.text = String(displayRaffle.price)
            raffleMax.text = String(displayRaffle.max)
            rafflePrize.text = String(displayRaffle.prize)
            raffleDrawDate.text = String(displayRaffle.draw_date)
            raffleStartDate.text = String(displayRaffle.start_date)
        } else
        {
            print("Didnt recieve raffle from segue")
        }
        
        /*
         * Code to close keyboard by selecting anywhere on the screen
         * Source: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
}
