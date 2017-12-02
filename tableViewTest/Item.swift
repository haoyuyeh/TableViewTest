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
    var image = UIImage(named: "object.png")
    var quantity = 0
    var price = 0.0
    var minPrice = 0.0
    var enableExpiredDay = false
    var purchasedDate = Date(timeIntervalSinceReferenceDate: 1)
    var expiredDate = Date(timeIntervalSinceReferenceDate: 1)
    init(name:String, quantity:Int, price: Double) {
        self.name = name
        self.quantity = quantity
        self.price = price
    }
}
