//
//  ViewController.swift
//  tableViewTest
//
//  Created by Hao Yu Yeh on 2017/12/2.
//  Copyright © 2017年 Hao Yu Yeh. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, AddItemTableViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var mainFolder = Folder(name: "main")

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
                folderName.keyboardType = .asciiCapable
            })
            let save = UIAlertAction(title: "Save", style: .default, handler: { (action) in
                self.mainFolder.containedFolders.append(Folder(name: (alert.textFields?.first?.text)!))
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainFolder.containedItems.count + mainFolder.containedFolders.count
    }
    // create existing cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let folderNum = mainFolder.containedFolders.count
        print("index path \(indexPath.row)")
        print("folder num \(folderNum)")
        print("item num \(mainFolder.containedItems.count)")

        // create folders first then items
        if indexPath.row < folderNum {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell")
            let folder = mainFolder.containedFolders[indexPath.row]
            cell?.textLabel?.text = folder.name
            cell?.imageView?.image = #imageLiteral(resourceName: "folder")
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
            let item = mainFolder.containedItems[indexPath.row - folderNum]
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
        if editingStyle == UITableViewCellEditingStyle.delete {
            let folderNum = mainFolder.containedFolders.count
            print("index path \(indexPath.row)")
            print("folder num \(folderNum)")
            print("item num \(mainFolder.containedItems.count)")
            
            // check which type should be deleted
            if indexPath.row < folderNum {
                mainFolder.containedFolders.remove(at: indexPath.row)
            }else {
                mainFolder.containedItems.remove(at: indexPath.row - folderNum)
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    // MARK: Add Item Delegate
    
    func addNew(item: Item) {
        mainFolder.containedItems.append(item)
    }
}

