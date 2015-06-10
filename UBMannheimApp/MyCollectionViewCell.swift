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
    
    var textLabel: UILabel!
    var imageView: UIImageView!
    var uiView: UIView!
    
    var outerUIView: UIView!
    var innerUIView: UIView!
    var textLabel2: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: CGRect(x: 0, y: 12, width: frame.size.width, height: frame.size.height*2/3))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    // contentView.addSubview(imageView)
        
        
        // uiView = UIView(frame: CGRect(x: 0, y: frame.size.height/1.5, width: frame.size.width, height: frame.size.height/3))
    // uiView.layer.cornerRadius = 10.0
    // contentView.addSubview(uiView)
        // textLabel.backgroundColor = UIColor.redColor()

        // rounded corners
        // http://stackoverflow.com/questions/25591389/uiview-with-shadow-rounded-corners-and-custom-drawrect
        
        // let textFrame = CGRect(x: 0, y: frame.size.height/1.5, width: frame.size.width, height: frame.size.height/3)
        let textFrame = CGRect(x: 0, y: frame.size.height/1.4, width: frame.size.width, height: frame.size.height/5)
        textLabel = UILabel(frame: textFrame)
        
        // textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.font = UIFont.systemFontOfSize(frame.size.height/10)
        textLabel.textColor = UIColor.grayColor()
        textLabel.textAlignment = .Center
        
    // contentView.addSubview(textLabel)
        
        outerUIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
        // imageView s.o.
        innerUIView = UIView(frame: CGRect(x: 0, y: frame.size.height/1.4, width: frame.size.width, height: frame.size.height/5))
        innerUIView.backgroundColor = UIColor.whiteColor()
        innerUIView.layer.cornerRadius = 10.0
        innerUIView.layer.opacity = 0.8
        // textLabel s.o.
        
        textLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/5))
        textLabel2.font = UIFont.systemFontOfSize(frame.size.height/10)
        textLabel2.textColor = UIColor.grayColor()
        textLabel2.textAlignment = .Center
        
        innerUIView.addSubview(textLabel2) // not added - but why?
        
        outerUIView.addSubview(imageView)
        outerUIView.addSubview(innerUIView)
        
        contentView.addSubview(outerUIView)
        contentView.addSubview(innerUIView)
        
    }
    
    func setMenuItem(item: MenuItem) {
        // self.backgroundColor = UIColor.blackColor()
        self.textLabel?.text = item.itemTitle
        self.textLabel2?.text = item.itemTitle
        self.imageView?.image = UIImage(named: item.itemImage)
    }
}
