//
//  MenuItem.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 30.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import Foundation

class MenuItem {
    
    var itemImage:String
    var itemTitle:String
    
    init(dataDictionary:Dictionary<String,String>) {
        itemImage = dataDictionary["itemImage"]!
        itemTitle = dataDictionary["itemTitle"]!
    }
    
    class func newMenuItem(dataDictionary:Dictionary<String,String>) -> MenuItem {
        return MenuItem(dataDictionary: dataDictionary)
    }
    
}
