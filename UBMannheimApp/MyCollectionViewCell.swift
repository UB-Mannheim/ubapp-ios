//
//  CollectionViewCell.swift
//  UBMannheimApp
//
//  Created by Brian Coleman on 2014-09-04.
//  Copyright (c) 2014 Brian Coleman. All rights reserved.
//
//  Last modified on 22.03.2016 by Alexander Wagner
//
//


import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    var DEBUG: Bool = false
    // if (DEBUG) {}
    
    var textLabel: UILabel!
    var imageView: UIImageView!
    var uiView: UIView!
    
    var outerUIView: UIView!
    var innerUIView: UIView!
    var textLabel2: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: CGRect(x: 0, y: 12, width: frame.size.width, height: frame.size.height*2/3))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        // Earlier sizing
        // let textFrame = CGRect(x: 0, y: frame.size.height/1.5, width: frame.size.width, height: frame.size.height/3)
        let textFrame = CGRect(x: 0, y: frame.size.height/1.4, width: frame.size.width, height: frame.size.height/5)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFont(ofSize: frame.size.height/10)
        textLabel.textColor = UIColor.gray
        textLabel.textAlignment = .center
        
        outerUIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
        
        if (DEBUG) { print("Frame Height: \(frame.size.height) Frame Width: \(frame.size.width)") }
        
        let model: String = UIDevice.current.model
        if (DEBUG) { print(model) }
        
        // LANDSCAPE
        if (frame.size.width > frame.size.height) {
            
            if( (model.range(of: "iPod") != nil) || (model.range(of: "iPhone") != nil) ) {
                innerUIView = UIView(frame: CGRect(x: frame.size.width/3.3, y: frame.size.height/1.2, width: frame.size.width/2.5, height: frame.size.height/5))
                textLabel2 = UILabel(frame: CGRect(x: -frame.size.width/3.3, y: 0, width: frame.size.width, height: frame.size.height/5))
            }
            
            if(model.range(of: "iPad") != nil) {
                imageView = UIImageView(frame: CGRect(x: 0, y: frame.size.height/4, width: frame.size.width, height: frame.size.height*2/3))
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                innerUIView = UIView(frame: CGRect(x: frame.size.width/4, y: frame.size.height/1.05, width: frame.size.width/2, height: frame.size.height/5))
                textLabel2 = UILabel(frame: CGRect(x: -frame.size.width/4, y: frame.size.height/80, width: frame.size.width, height: frame.size.height/5))
            }
    
        // PORTRAIT
        } else {
            if(model.range(of: "iPod") != nil) {
                innerUIView = UIView(frame: CGRect(x: 0, y: frame.size.height/1.4, width: frame.size.width, height: frame.size.height/5))
                textLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/5))
            }
        
            if(model.range(of: "iPad") != nil) {
                imageView = UIImageView(frame: CGRect(x: 0, y: frame.size.height/8, width: frame.size.width, height: frame.size.height*2/3))
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                innerUIView = UIView(frame: CGRect(x: frame.size.width/19, y: frame.size.height/1.2, width: frame.size.width/1.12, height: frame.size.height/5))
                textLabel2 = UILabel(frame: CGRect(x: -frame.size.width/19, y: frame.size.height/100, width: frame.size.width, height: frame.size.height/5))
            }
            
            if(model.range(of: "iPhone") != nil) {
                innerUIView = UIView(frame: CGRect(x: 0, y: frame.size.height/1.3, width: frame.size.width, height: frame.size.height/5))
                textLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/5))
            }
            
        }
        
        innerUIView.backgroundColor = UIColor.white
        innerUIView.layer.cornerRadius = 10.0
        innerUIView.layer.opacity = 0.8
        
        textLabel2.font = UIFont.systemFont(ofSize: frame.size.height/10)
        textLabel2.textColor = UIColor.gray
        textLabel2.textAlignment = .center
        
        innerUIView.addSubview(textLabel2)
        outerUIView.addSubview(imageView)
        contentView.addSubview(outerUIView)
        // hide sub-labels below icons
        contentView.addSubview(innerUIView)
        
    }
    
    func setMenuItem(_ item: MenuItem) {
        // self.backgroundColor = UIColor.blackColor()
        self.textLabel?.text = item.itemTitle
        self.textLabel2?.text = item.itemTitle
        self.imageView?.image = UIImage(named: item.itemImage)
    }
}
