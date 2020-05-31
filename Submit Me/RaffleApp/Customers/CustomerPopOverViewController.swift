//
//  CustomerPopOverViewController.swift
//  KIT305 AT2
//
//  Created by Lucas Howlett on 19/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

protocol PassCustomerProtocol : class{
    func passCustomer(_ sentCustomer: Customer)
}

class CustomerPopOverViewController: UIViewController, SelectCustomerCellProtocol {
    var customer: Customer? {
        didSet{
            delegateTwo?.passCustomer(customer!)
            self.view.removeFromSuperview()
        }
    }
    weak var delegateTwo: PassCustomerProtocol?
    
    func customerSelected(_ sentCustomer: Customer) {
        customer = sentCustomer
        print("customer recieved from selection")
        print(customer?.customer_name ?? "")
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowCustomerListEmbedSegue"
        {
            guard let CustomerUITableViewController = segue.destination as? CustomerUITableViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let CustomerPopOverViewController = sender as? CustomerPopOverViewController else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            CustomerUITableViewController.delegate = self
        }
    }

}
