//
//  DetailViewController.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class RaffleDetailViewController: UIViewController {

    var raffle : Raffle?
    
    @IBOutlet var   titleLabel: UILabel!
    @IBOutlet var   yearLabel: UILabel!
    @IBOutlet var   directorLabel: UILabel!
    
    @IBOutlet var sellTicketButton: UIButton!
    @IBOutlet var drawWinnerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let  displayRaffle = raffle
        {
            titleLabel.text = displayRaffle.raffle_name
            yearLabel.text = String(displayRaffle.draw_date.prefix(10))
            directorLabel.text = String(displayRaffle.prize)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
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
    }
}
