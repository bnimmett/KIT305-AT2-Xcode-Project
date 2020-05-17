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
    
    @IBOutlet var raffleName: UITextField!
    @IBOutlet var rafflePrice: UITextField!
    @IBOutlet var raffleMax: UITextField!
    @IBOutlet var rafflePrize: UITextField!
    @IBOutlet var raffleDrawDate: UITextField!
    
    
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
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        var empty = false
        
        if(raffleName.text == "" || rafflePrice.text == "" || rafflePrize.text == "" || raffleMax.text == "" || raffleDrawDate.text == "")
        {
            empty = true
            emptyAlert()
        }
        
        if(!empty)
        {
            let database : SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")
            let updateRaffle = Raffle(
                raffle_id: raffle?.raffle_id ?? -1,
                raffle_name:raffleName.text!,
                draw_date:raffleDrawDate.text!,
                start_date:raffle!.start_date,
                price:Double(rafflePrice.text!) ?? 0,
                prize:Int32(rafflePrize.text!) ?? 0,
                pool:raffle!.pool,
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
        pool:raffle!.pool,
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        raffleName.returnKeyType = UIReturnKeyType.done
        rafflePrice.returnKeyType = UIReturnKeyType.done
        rafflePrize.returnKeyType = UIReturnKeyType.done
        raffleDrawDate.returnKeyType = UIReturnKeyType.done
        
        if let displayRaffle = raffle
        {
            raffleName.text = displayRaffle.raffle_name
            rafflePrice.text = String(displayRaffle.price)
            raffleMax.text = String(displayRaffle.max)
            rafflePrize.text = String(displayRaffle.prize)
            raffleDrawDate.text = String(displayRaffle.draw_date)
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
