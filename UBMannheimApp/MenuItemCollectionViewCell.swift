//
//  MenuItemCollectionViewCell.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 30.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit
    

class MenuItemCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var itemImageView: UIImageView!
    
    func setMenuItem(item: MenuItem) {
        itemImageView.image = UIImage(named: item.itemImage)
    }
    
}

