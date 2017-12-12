//
//  ViewController.swift
//  tableViewTest
//
//  Created by Hao Yu Yeh on 2017/12/2.
//  Copyright © 2017年 Hao Yu Yeh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, AddItemTableViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var items = [Item]()
    
    // MARK: View Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        // refresh the view to show new item
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        items.append(Item(name: "juice", quantity: 2, price: 1.5))
    }
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            let destVC = segue.destination as! AddItemTableViewController
            destVC.delegate = self
        }else if segue.identifier == "EditItemSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let destVC = segue.destination as! AddItemTableViewController
            let item = items[(indexPath?.row)!]
            destVC.item = item
        }
    }
    
    // MARK: Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
        let item = items[indexPath.row]
        cell?.textLabel?.text = item.name
        cell?.detailTextLabel?.text = "Quantity: " + String(item.quantity) + " , Price: " + String(item.price)
        cell?.imageView?.image = item.image
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    // MARK: Add Item Delegate
    
    func addNew(item: Item) {
        items.append(item)
        
    }
}

