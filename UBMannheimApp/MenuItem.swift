//
//  MenuItem.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 30.03.15.
//  Last modified on 22.03.16.
//
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//
//

import Foundation

class MenuItem {
    
    var itemImage:String
    var itemTitle:String
    
    init(dataDictionary:Dictionary<String,String>) {
        itemImage = dataDictionary["itemImage"]!
        itemTitle = dataDictionary["itemTitle"]!
    }
    
    class func newMenuItem(_ dataDictionary:Dictionary<String,String>) -> MenuItem {
        return MenuItem(dataDictionary: dataDictionary)
    }
    
}
