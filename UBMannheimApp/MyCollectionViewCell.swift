//
//  CollectionViewCell.swift
//  UBMannheimApp
//
//  Created by Brian Coleman on 2014-09-04.
//  Copyright (c) 2014 Brian Coleman. All rights reserved.
//
//  Modified by Alexander Wagner on 13.04.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.


import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let textLabel: UILabel!
    let imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 12, width: frame.size.width, height: frame.size.height*2/3))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        
        let textFrame = CGRect(x: 0, y: frame.size.height/1.5, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        // textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.font = UIFont.systemFontOfSize(frame.size.height/10)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
    }
    
    func setMenuItem(item: MenuItem) {
        // self.backgroundColor = UIColor.blackColor()
        self.textLabel?.text = item.itemTitle
        self.imageView?.image = UIImage(named: item.itemImage)
    }
}
