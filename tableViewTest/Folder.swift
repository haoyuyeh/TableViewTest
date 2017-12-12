//
//  Folder.swift
//  tableViewTest
//
//  Created by Hao Yu Yeh on 2017/12/12.
//  Copyright © 2017年 Hao Yu Yeh. All rights reserved.
//

import Foundation

class Folder {
    var name = ""
    var containedItems = [Item]()
    var containedFolders = [Folder]()
    
    init(name: String) {
        self.name = name
    }
}
