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

class AddItemTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var item : Item? = nil
    var delegate: AddItemTableViewControllerDelegate!
    let datePicker = UIDatePicker()
    
    let keyboardToolbar = UIToolbar()
    let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveClicked))
    let segmentController = UISegmentedControl(items: ["previous", "next"])
    
    // MARK: IBOutlets
    
    @IBOutlet weak var addItemTableView: UITableView!
    
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
        if item == nil {
            createItem()
        }else {
            editItem()
        }
        // delete current view controller and show the previous one
        // switch the view from 'add item' to 'item list'
        navigationController?.popViewController(animated: true)
    }
    @IBAction func reminderValueChanged(_ sender: UISwitch) {
        tableView.reloadData()
    }
    
    // MARK: Helper Methods
    
    func createItem() {
        item = Item(name: itemName.text!, quantity: Int(itemQuantity.text!)!, price: Double(itemPrice.text!)!)
        item?.image = itemImage.image!
        item?.purchasedDate = itemPurchaseDate.text!
        item?.expiredDateReminder = itemExpiredDateReminder.isOn
        item?.expiredDate = itemExpiredDate.text!
        delegate.addNew(item: item!)
    }
    
    func editItem() {
        item?.image = itemImage.image!
        item?.name = itemName.text!
        item?.quantity = Int(itemQuantity.text!)!
        item?.price = Double(itemPrice.text!)!
        item?.purchasedDate = itemPurchaseDate.text!
        item?.expiredDateReminder = itemExpiredDateReminder.isOn
        item?.expiredDate = itemExpiredDate.text!
    }
    
    func showItem() {
        itemImage.image = item?.image
        itemName.text = item?.name
        itemQuantity.text = "\(item?.quantity ?? 1)"
        itemPrice.text = "\(item?.price ?? 0.0)"
        itemMinPrice.text = "\(item?.minPrice ?? 0.0)"
        itemPurchaseDate.text = item?.purchasedDate
        itemExpiredDateReminder.isOn = (item?.expiredDateReminder)!
        itemExpiredDate.text = item?.expiredDate
    }
    
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // entering edit mode
        if item != nil {
            showItem()
        }
        
        // create a toolbar for keyboard
//        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        // add segment control into toolbar
//        let segmentController = UISegmentedControl(items: ["previous", "next"])
        let segmentControlButton = UIBarButtonItem(customView: segmentController)
        segmentController.addTarget(self, action: #selector(self.segmentControl), for:UIControlEvents.allEvents)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
//        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveClicked))
        keyboardToolbar.setItems([segmentControlButton, flexibleSpace, saveButton, doneButton], animated: false)
        saveButton.isEnabled = false
        // format for date picker
        datePicker.datePickerMode = .date
        
        itemName.delegate = self
        itemName.inputAccessoryView = keyboardToolbar
        itemQuantity.delegate = self
        itemQuantity.inputAccessoryView = keyboardToolbar
        itemPrice.delegate = self
        itemPrice.inputAccessoryView = keyboardToolbar
        itemPurchaseDate.delegate = self
        itemPurchaseDate.inputView = datePicker
        itemPurchaseDate.inputAccessoryView = keyboardToolbar
        itemExpiredDate.delegate = self
        itemExpiredDate.inputView = datePicker
        itemExpiredDate.inputAccessoryView = keyboardToolbar
        
        ///  step.1 Add tap gesture to view
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
//        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// step.3 Add observers to receive 'UIKeyboardWillShow' and 'UIKeyboardWillHide' notification
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// step.3 remove observers to Not receive notification when viewController is in the background
        removeObservers()
    }
    
    // MARK: fix keyboard occlusion methods
    
    /// step.2 Add method to handle tap event on the view and dismiss keyboard
//    @objc func didTapView(gesture: UITapGestureRecognizer) {
//        // this should hide keyboard for the view
//        view.endEditing(true)
//    }
    
    /// step.3 Add observers for 'UIKeyboardWillShow' and 'UIKeyboardWillHide' notification
    func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    /// step.6 Method to remove observers
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// step.4 Add method to handle keyboardWillShow notification, we're using this method to adjust scrollview to show hidden textField under keyboard
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    
    /// step.5 Method to reset scrollview when keyboard is hidden
    func keyboardWillHide(notification: Notification) {
        tableView.contentInset = UIEdgeInsets.zero
    }
    
    

    // MARK: Keyboard Toolbar Button Methods
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @objc func saveClicked() {
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
    }
    /**
        using segment controller to switch textFields needed editing
     */
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
            // turn on/off the reminder and expand/collapse cells
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
        // use to expand/collapse cells
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
    
    // MARK: TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if itemName.isFirstResponder {
            segmentController.setEnabled(false, forSegmentAt: 0)
            segmentController.setEnabled(true, forSegmentAt: 1)
            saveButton.isEnabled = false
        }else if itemExpiredDate.isFirstResponder {
            segmentController.setEnabled(true, forSegmentAt: 0)
            segmentController.setEnabled(false, forSegmentAt: 1)
            saveButton.isEnabled = true
        }else {
            segmentController.setEnabled(true, forSegmentAt: 0)
            segmentController.setEnabled(true, forSegmentAt: 1)
            if itemPurchaseDate.isFirstResponder {
                saveButton.isEnabled = true
            }else {
                saveButton.isEnabled = false
            }            
        }
    }
}
