//
//  MenuItemCollectionViewCell.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 30.03.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//

import UIKit
    

class MenuItemCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleView: UILabel!
    
    func setMenuItem(_ item: MenuItem) {
        itemImageView.image = UIImage(named: item.itemImage)
        itemTitleView.text = item.itemTitle
    }
    
}

