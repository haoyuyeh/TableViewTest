//
//  AddItemTableViewController.swift
//  tableViewTest
//
//  Created by Hao Yu Yeh on 2017/12/10.
//  Copyright © 2017年 Hao Yu Yeh. All rights reserved.
//

import UIKit

protocol AddItemTableViewControllerDelegate {
    func addNew(item: Item)
}

class AddItemTableViewController: UITableViewController {

    var delegate: AddItemTableViewControllerDelegate!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemMinPrice: UITextField!
    @IBOutlet weak var itemPurchaseDate: UITextField!
    
    // MARK: IBActions
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        let item = Item(name: itemName.text!, quantity: Int(itemQuantity.text!)!, price: Double(itemPrice.text!)!)
        delegate.addNew(item: item)
        // delete current view controller and show the previous one
        navigationController?.popViewController(animated: true)
    }
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Table View Delegate Methods
    
    
}
