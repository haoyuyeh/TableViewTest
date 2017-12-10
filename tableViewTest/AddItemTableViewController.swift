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
    func showDetail() -> Item
}

class AddItemTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate: AddItemTableViewControllerDelegate!
    let datePicker = UIDatePicker()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemMinPrice: UITextField!
    @IBOutlet weak var itemPurchaseDate: UITextField!
    @IBOutlet weak var itemExpiredDate: UITextField!
    @IBOutlet weak var itemExpiredDateReminder: UISwitch!
    
    // MARK: IBActions
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        let item = Item(name: itemName.text!, quantity: Int(itemQuantity.text!)!, price: Double(itemPrice.text!)!)
        item.image = itemImage.image!
        item.purchasedDate = itemPurchaseDate.text!
        item.expiredDate = itemExpiredDate.text!
        delegate.addNew(item: item)
        // delete current view controller and show the previous one
        // switch the view from 'add item' to 'item list'
        navigationController?.popViewController(animated: true)
    }
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create a toolbar for keyboard
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        // add segment control into toolbar
        let segmentController = UISegmentedControl(items: ["previous", "next"])
        let segmentControlButton = UIBarButtonItem(customView: segmentController)
        segmentController.addTarget(self, action: #selector(self.segmentControl), for:.allEvents)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        keyboardToolbar.setItems([segmentControlButton, flexibleSpace, doneButton], animated: false)
        
        // format for date picker
        datePicker.datePickerMode = .date
        
        itemName.inputAccessoryView = keyboardToolbar
        itemQuantity.inputAccessoryView = keyboardToolbar
        itemPrice.inputAccessoryView = keyboardToolbar
        itemPurchaseDate.inputView = datePicker
        itemPurchaseDate.inputAccessoryView = keyboardToolbar
        itemExpiredDate.inputView = datePicker
        itemExpiredDate.inputAccessoryView = keyboardToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let item = delegate.showDetail()
        itemImage.image = item.image
        itemName.text = item.name
        itemQuantity.text = String(item.quantity)
        itemPrice.text = String(item.price)
        itemPurchaseDate.text = item.purchasedDate
        itemExpiredDate.text = item.expiredDate
    }

    // MARK: Keyboard Toolbar Button Methods
    
    @objc func doneClicked() {
        // date format
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        if itemPurchaseDate.isFirstResponder {
            itemPurchaseDate.text = dateFormatter.string(from: datePicker.date)
        }else if itemExpiredDate.isFirstResponder {
            itemExpiredDate.text = dateFormatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    @objc func segmentControl(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if itemQuantity.isFirstResponder {
                itemName.becomeFirstResponder()
            }else if itemPrice.isFirstResponder {
                itemQuantity.becomeFirstResponder()
            }else if itemPurchaseDate.isFirstResponder {
                itemPrice.becomeFirstResponder()
            }else if itemExpiredDate.isFirstResponder {
                itemPurchaseDate.becomeFirstResponder()
            }
            sender.selectedSegmentIndex = UISegmentedControlNoSegment
        }else if sender.selectedSegmentIndex == 1 {
            if itemName.isFirstResponder {
                itemQuantity.becomeFirstResponder()
            }else if itemQuantity.isFirstResponder {
                itemPrice.becomeFirstResponder()
            }else if itemPrice.isFirstResponder {
                itemPurchaseDate.becomeFirstResponder()
            }else if itemPurchaseDate.isFirstResponder {
                itemExpiredDate.becomeFirstResponder()
            }
            sender.selectedSegmentIndex = UISegmentedControlNoSegment
        }
    }
    
    // MARK: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // use image picker to take picture of item
        if indexPath.section == 0 && indexPath.row == 0 {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }else if indexPath.section == 2 && indexPath.row == 0 {
            itemExpiredDateReminder.setOn(!itemExpiredDateReminder.isOn, animated: true)
            tableView.reloadData()
        }else if (indexPath.section == 1 && indexPath.row != 3) || (indexPath.section == 2 && indexPath.row == 1) {
            // touch the cell to enable the editing of textField
            let cell = tableView.cellForRow(at: indexPath)
            if let subviews = cell?.contentView.subviews {
                for view in subviews {
                    if let textField = view as? UITextField {
                        textField.becomeFirstResponder()
                        break
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 201.0
        }
        if indexPath.section == 2 {
            if itemExpiredDateReminder.isOn == false && indexPath.row == 1 {
                return 0.0
            }
        }
        return 44.0
    }
    
    // MARK: Image Picker Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        itemImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
