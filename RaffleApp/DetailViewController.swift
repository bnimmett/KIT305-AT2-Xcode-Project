//
//  DetailViewController.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var movie : Movie?
    
    @IBOutlet var   titleLabel: UILabel!
    @IBOutlet var   yearLabel: UILabel!
    @IBOutlet var   directorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let  displayMovie = movie
        {
            titleLabel.text = displayMovie.name
            yearLabel.text = String(displayMovie.year)
            directorLabel.text = displayMovie.director
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
