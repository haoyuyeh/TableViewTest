//
//  ViewController.swift
//  tableViewTest
//
//  Created by Hao Yu Yeh on 2017/12/2.
//  Copyright © 2017年 Hao Yu Yeh. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, AddItemTableViewControllerDelegate {
    
    // MARK: global variables
    let sectionTitles = ["Folders", "Items"]
    var mainFolder = Folder(name: "main")
    
    enum itemCompareType {
        case name
        case purchaseDate
        case expiredDate
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    

    // MARK: IBAction
    
    // show action sheet for multiple choices
    // and use alert to let user enter folder's name
    // if they intend to create a new folder
    @IBAction func plusButtonTapped(_ sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let newItem = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "AddItemViewControllerID") as! AddItemTableViewController
            destVC.delegate = self
            // if the view contains navi bar, using present function will not show the navi bar
            //self.present(destVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(destVC, animated: true)
        }
        
        let newFolder = UIAlertAction(title: "Add Folder", style: .default) { (action) in
            let alert = UIAlertController(title: "Add Folder", message: "Enter folder's name.", preferredStyle: .alert)
            
            // create a textfield to retrieve folder's name
            alert.addTextField(configurationHandler: { (folderName) in
                folderName.placeholder = "Folder's Name"
                folderName.keyboardType = .default
                folderName.autocorrectionType = .yes
            })
            let save = UIAlertAction(title: "Save", style: .default, handler: { (action) in
                self.mainFolder.containedFolders.append(Folder(name: (alert.textFields?.first?.text)!))
                self.mainFolder.containedFolders = self.folderCustomSort(target: self.mainFolder.containedFolders, order: .orderedAscending)
                self.tableView.reloadData()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(save)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(newItem)
        sheet.addAction(newFolder)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
    }
    
    
    // MARK: View Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        // refresh the view to show new item
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove empty cells
        tableView.tableFooterView = UIView()
        mainFolder.containedItems.append(Item(name: "juice", quantity: 2, price: 1.5))
    }
    
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // switch view to add item view to edit properties of item
        if segue.identifier == "EditItemSegue" {
            let itemDestVC = segue.destination as! AddItemTableViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            // calculate item's index due to the possiblity of having folders
            let index = (indexPath?.row)! - mainFolder.containedFolders.count
            let item = mainFolder.containedItems[index]
            itemDestVC.item = item
        }
    }
    
    // MARK: Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mainFolder.containedFolders.count
        }else {
            return mainFolder.containedItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // create existing cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell")
            let folder = mainFolder.containedFolders[indexPath.row]
            cell?.textLabel?.text = folder.name
            cell?.imageView?.image = #imageLiteral(resourceName: "folder")
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
            let item = mainFolder.containedItems[indexPath.row]
            cell?.textLabel?.text = item.name
            cell?.detailTextLabel?.text = "Quantity: " + String(item.quantity) + " , Price(per unit): " + String(item.price)
            cell?.imageView?.image = item.image
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // delete cells
        if editingStyle == UITableViewCellEditingStyle.delete {
            if indexPath.section == 0 {
                mainFolder.containedFolders.remove(at: indexPath.row)
            }else {
                mainFolder.containedItems.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    // MARK: Add Item Delegate
    
    func addNew(item: Item) {
        mainFolder.containedItems.append(item)
        mainFolder.containedItems = itemCustomSort(target: mainFolder.containedItems, by: .name, order: .orderedAscending)
    }
    
    // MARK: Helper methods
    
    func itemCustomSort(target: Array<Item>, by: itemCompareType, order: ComparisonResult) -> Array<Item> {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        switch by {
        case .purchaseDate:
            return target.sorted(by: { (t1, t2) -> Bool in
                return dateFormatter.date(from: t1.purchasedDate)?.compare(dateFormatter.date(from: t2.purchasedDate)!)  == order
            })
        case .expiredDate:
            return target.sorted(by: { (t1, t2) -> Bool in
                return dateFormatter.date(from: t1.expiredDate)?.compare(dateFormatter.date(from: t2.expiredDate)!)  == order
            })
        default:
            return target.sorted { (t1, t2) -> Bool in
                return t1.name.localizedStandardCompare(t2.name) == order
            }
        }
    }
    
    func folderCustomSort(target: Array<Folder>, order: ComparisonResult) -> Array<Folder> {
        return target.sorted { (t1, t2) -> Bool in
            return t1.name.localizedStandardCompare(t2.name) == order
        }
    }
}

