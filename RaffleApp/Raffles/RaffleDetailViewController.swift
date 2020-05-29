//
//  DetailViewController.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var raffle : Raffle?
    
    
    @IBOutlet var   raffleNameText: UITextField!
    @IBOutlet var   raffleDescription: UILabel!
    @IBOutlet var   raffleDrawDate: UILabel!
    @IBOutlet var   rafflePrize: UILabel!
    @IBOutlet var   raffleSold: UILabel!
    @IBOutlet var   raffleMax: UILabel!
    @IBOutlet var   rafflePrice: UILabel!
    @IBOutlet var   addImageButton: UIButton!
    @IBOutlet var   marginLabel: UILabel!
    
    @IBOutlet var   sellTicketButton: UIButton!
    @IBOutlet var   drawWinnerButton: UIButton!
    
    @IBOutlet var   imageView: UIImageView!
    
    @IBAction func AddPhotoButtonTapped(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("No Photo Library Avaliable")
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView?.image = image
            addImageButton.isHidden = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addToolbar(title: String)
    {
        let toolbar = UIToolbar()
 
        toolbar.sizeToFit()
     
        //toolbar with button for all regular textfield keyboards
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        //set button on right
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
       
        let text = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        text.tintColor = UIColor.black
        toolbar.setItems([text, flexSpace, doneButton], animated: true)

        
      //  let text = UIBarItem
        //add each toolbar to keyboard
        raffleNameText.inputAccessoryView = toolbar
    
    }
    
    @objc func doneButtonPressed()
    {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "my_database")
        let updateRaffle = Raffle(
            raffle_id: raffle?.raffle_id ?? -1,
            raffle_name:raffleNameText.text!,
            raffle_description:raffle!.raffle_description,
            draw_date:raffle!.draw_date,
            start_date:raffle!.start_date,
            price:raffle!.price,
            prize:raffle!.prize,
            max:raffle!.max,
            current:raffle!.current,
            margin:raffle!.margin,
            archived:false
        )
        if updateRaffle.raffle_id == -1 {
            print("Error Raffle Name not updated")
        } else {
            database.update(raffle:updateRaffle)
            print("Raffle \(raffle?.raffle_id ?? -2) updated")
        }
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let  displayRaffle = raffle
        {
            
//            raffleDescription.text = displayRaffle.raffle_description
        
            let drawDate = displayRaffle.draw_date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS.000"
            let textDrawDate = dateFormatter.date(from: drawDate)
            dateFormatter.dateFormat = "dd/MM/YYYY, HH:mm"
            
            raffleNameText.text = displayRaffle.raffle_name
            raffleDescription.text = displayRaffle.raffle_description
            raffleDrawDate.text = dateFormatter.string(from: textDrawDate!)
            rafflePrize.text = String(displayRaffle.prize)
            rafflePrice.text = String(displayRaffle.price)
            raffleMax.text = String(displayRaffle.max)
            if displayRaffle.margin {
//                marginLabel.text = "Margin Draw"
            }
            else {
//                marginLabel.text = "Random Draw"
            }
            
            print(displayRaffle.raffle_id)
            
            //When backbutton is pressed, will always return to raffle list and not new ticket view.
            if let returnToRoot = navigationController?.viewControllers.first {
                navigationController?.viewControllers = [returnToRoot, self]
            }
        }
        
        addToolbar(title: "Edit Raffle Name")
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        raffle = database.selectRaffleByID(raffle_id: raffle?.raffle_id ?? -1)
        raffleSold.text = String(raffle?.current ?? -1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "EditRaffleSegue"
        {
            guard let EditRaffleViewController = segue.destination as? EditRaffleViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let editButton = sender as? UIBarItem else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            EditRaffleViewController.raffle = raffle
        }
        
        if segue.identifier == "ShowNewTicketSegue"
        {
            guard let NewTicketViewController = segue.destination as? NewTicketViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let currentRaffle = sender as? UIButton else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            NewTicketViewController.raffle = raffle
        }
    
        if segue.identifier == "ShowTicketTableSegue"
        {
            guard let TicketUITableViewController = segue.destination as? TicketUITableViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let RaffleDetailViewController = sender as? RaffleDetailViewController else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            TicketUITableViewController.raffle = raffle
        }
        
        if segue.identifier == "DrawWinnerSegue"
        {
            guard let DrawTicketViewController = segue.destination as? DrawTicketViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let currentRaffle = sender as? UIButton else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
        
            DrawTicketViewController.raffle = raffle
        }
        
    }
}
