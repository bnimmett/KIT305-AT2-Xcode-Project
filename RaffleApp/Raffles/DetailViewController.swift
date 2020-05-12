//
//  DetailViewController.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var raffle : Raffle?
    
    @IBOutlet var   titleLabel: UILabel!
    @IBOutlet var   yearLabel: UILabel!
    @IBOutlet var   directorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let  displayRaffle = raffle
        {
            titleLabel.text = displayRaffle.raffle_name
            yearLabel.text = String(displayRaffle.draw_date.prefix(10))
            directorLabel.text = String(displayRaffle.prize)
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
