//
//  ViewController.swift
//  tableViewTest
//
//  Created by Hao Yu Yeh on 2017/12/2.
//  Copyright © 2017年 Hao Yu Yeh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var items = [Item]()
    
    // MARK : View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items.append(Item(name: "juice", quantity: 2, price: 1.5))
    }
    
    // MARK : Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
        let item = items[indexPath.row]
        cell?.textLabel?.text = item.name
        cell?.detailTextLabel?.text = "Quantity:" + String(item.quantity) + ", Price:" + String(item.price)
        cell?.imageView?.image = item.image
        return cell!
    }
}

