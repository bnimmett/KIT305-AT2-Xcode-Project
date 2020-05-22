//
//  DrawTicketViewController.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 22/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class DrawTicketViewController: UIViewController {

    var raffle: Raffle?
    var tickets = [Ticket]()
    var numWinners: Int32?
    
    @IBOutlet var inputMarginTextField: UITextField!
    
    
    @IBAction func drawRandomButton(_ sender: UIButton) {
        drawAlert()
    }
    
    func drawRaffle(){
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        numWinners = database.selectWinningTicketCountByRaffle(raffle_id: raffle?.raffle_id ?? -1)
        var winner = tickets.randomElement()
        winner?.win = (numWinners ?? 0) + 1
        database.update(ticket: winner ?? Ticket(
            raffle_id: -1,
            customer_id: -1,
            number: 0,
            win: 0))
        let child = self.children[0] as? WinningTicketTableViewController
        child?.reloadTable()
    }
    
    @IBAction func drawMarginButton(_ sender: Any) {
        if inputMarginTextField.text != "" {
            marginDrawAlert()
        }
        else {
            alert(Title: "Empty margin", Message: "You must input a margin to draw the raffle")
        }
    }
    
    func drawMarginRaffle(){
        var winner: Ticket? = nil
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        let margin = Int32(inputMarginTextField.text ?? "0") ?? 0
        if let raffle_id = raffle?.raffle_id {
            numWinners = database.selectWinningTicketCountByRaffle(raffle_id: raffle_id)
            winner = database.selectWinningMarginTicketByRaffle(raffle_id: raffle_id, margin: margin)
        }
        if winner != nil && winner?.number != -2 {
            winner!.win = (numWinners ?? 0) + 1
            database.update(ticket: winner!)
            let child = self.children[0] as? WinningTicketTableViewController
            child?.reloadTable()
        }
        else {
            alert(Title: "No winner", Message: "No ticket won from margin \(margin).")
        }
        inputMarginTextField.text = ""
        
    }
    
    private func alert(Title:String, Message:String) //REF[3]
    {
        let emptyAlertController = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        emptyAlertController.addAction(dismissAction)
     
        present(emptyAlertController, animated: true, completion: nil)
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
        inputMarginTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonPressed()
    {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToolbar()

        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        print("Loading Tickets")
        if let raffle_id = raffle?.raffle_id {
            tickets = database.selectNonWinningTicketsByRaffle(raffle_id: raffle_id)
            print("Tickets Loaded, for raffle \(raffle_id)")
        }
        else{
            print("Tickets not Loaded, for raffle \(raffle?.raffle_id ?? -1)")
        }
        
        /*
         * Code to close keyboard by selecting anywhere on the screen
         * Source: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func drawAlert()
    {
        let drawAlertController = UIAlertController(title: "Draw a Winner", message:"Are you sure you want to Draw this raffle?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { _ in
        }
        let drawAction = UIAlertAction.init(title: "Draw", style: .destructive) { _ in
            self.drawRaffle()
        }
         
        drawAlertController.addAction(cancelAction)
        drawAlertController.addAction(drawAction)
        
        present(drawAlertController, animated: true, completion: nil)
    }
    
    private func marginDrawAlert()
    {
        let marginDrawAlertController = UIAlertController(title: "Draw Margin Winner", message:"Are you sure you want to Margin Draw this raffle?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { _ in
        }
        let drawAction = UIAlertAction.init(title: "Draw", style: .destructive) { _ in
            self.drawMarginRaffle()
        }
         
        marginDrawAlertController.addAction(cancelAction)
        marginDrawAlertController.addAction(drawAction)
        
        present(marginDrawAlertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowWinningTicketTable"
        {
            guard let WinningTicketTableViewController = segue.destination as? WinningTicketTableViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let DrawTicketViewController = sender as? DrawTicketViewController else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            WinningTicketTableViewController.raffle = raffle
        }
    }
    

}
