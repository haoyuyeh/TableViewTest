//
//  Item.swift
//  tableViewTest
//
//  Created by Hao Yu Yeh on 2017/12/3.
//  Copyright © 2017年 Hao Yu Yeh. All rights reserved.
//

import Foundation
import UIKit

class Item {
    var name = ""
    var image = #imageLiteral(resourceName: "defaultObj")
    var quantity = 0
    var price = 0.0
    var minPrice = 0.0
    var expiredDateReminder = false
    var purchasedDate = ""
    var expiredDate = ""
    
    init(name:String, quantity:Int, price: Double) {
        self.name = name
        self.quantity = quantity
        self.price = price
    }
}
