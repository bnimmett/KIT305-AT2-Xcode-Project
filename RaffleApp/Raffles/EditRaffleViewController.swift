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
    @IBOutlet var raffleDescription: UITextField!

    let drawDatePicker = UIDatePicker()
    let startDatePicker = UIDatePicker()
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        var empty = false
        
        if(raffleNameField.text == "" || raffleDescription.text == "" || rafflePrice.text == "" || rafflePrize.text == "" || raffleMax.text == "" || raffleDrawDate.text == "")
        {
            empty = true
            emptyAlert()
        }
        //print(raffleDrawDate.text)
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")
            let updateRaffle = Raffle(
                raffle_id: raffle?.raffle_id ?? -1,
                raffle_name:raffleNameField.text!,
                raffle_description:raffleDescription.text!,
                draw_date:raffleDrawDate.text!,
                start_date:raffle!.start_date,
                price:Double(rafflePrice.text!) ?? 0,
                prize:Int32(rafflePrize.text!) ?? 0,
                max:Int32(raffleMax.text!) ?? 0,
                current:raffle!.current,
                margin:raffle!.margin,
                archived:false
            )
            if updateRaffle.raffle_id == -1 {
                print("Error Raffle not updated")
                //add alert
                self.navigationController!.popViewController(animated: true)
            } else {
                database.update(raffle:updateRaffle)
                print("Raffle \(raffle?.raffle_id ?? -2) updated")
                self.navigationController!.popViewController(animated: true)
                self.navigationController!.popViewController(animated: true)            }
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
        raffle_description:raffle!.raffle_description,
        draw_date:raffle!.draw_date,
        start_date:raffle!.start_date,
        price:raffle!.price,
        prize:raffle!.prize,
        max:raffle!.max,
        current:raffle!.current,
        margin:raffle!.margin,
        archived:true
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
        let database :SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")
        let raffleId = raffle?.raffle_id ?? -1
        let ticket_count = database.selectTicketCountByRaffle(raffle_id: raffleId)
        
        if ticket_count == 0 {
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
            
        else {
            let deleteAlertController = UIAlertController(title: "Can't Delete", message:"You can't delete a raffle after it has started (sold a tiket)", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { _ in
            }
             
            deleteAlertController.addAction(cancelAction)
            
            present(deleteAlertController, animated: true, completion: nil)
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
        rafflePrice.inputAccessoryView = toolbar
        rafflePrize.inputAccessoryView = toolbar
        raffleMax.inputAccessoryView = toolbar
        raffleDescription.inputAccessoryView = toolbar
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
            raffleDescription.text = displayRaffle.raffle_description
        } else
        {
            print("Didnt recieve raffle from segue")
        }
        
    
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
}
