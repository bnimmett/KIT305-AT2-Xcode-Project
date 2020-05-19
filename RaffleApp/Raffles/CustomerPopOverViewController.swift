//
//  CustomerPopOverViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 19/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class CustomerPopOverViewController: UIViewController {
    

    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
    }
    

    

}
