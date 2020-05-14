//
//  SellTicketsViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 14/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class SellTicketsViewController: UIViewController {
    
    var raffle : Raffle?
    
    @IBOutlet var sellTitle: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let displayRaffle = raffle
        {
            sellTitle.text = displayRaffle.raffle_name
        }
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
