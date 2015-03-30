//
//  MainController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 26.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    // http://swiftiostutorials.com/tutorial-using-uicollectionview-uicollectionviewflowlayout
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMenuItems()
        collectionView.reloadData()
    }
    
    private func initMenuItems() {
        
        var items = [MenuItem]()
        
        let inputFile = NSBundle.mainBundle().pathForResource("items", ofType: "plist")
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as [Dictionary<String, String>] {
            let menuItem = MenuItem(dataDictionary: inputItem)
            items.append(menuItem)
        }
        
        menuItems = items
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuItemCollectionViewCell", forIndexPath: indexPath) as MenuItemCollectionViewCell
        
        cell.setMenuItem(menuItems[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // reservierter platz fuer bild
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimensionX = self.view.frame.size.width / 2.5 // 16.0
        let picDimensionY = self.view.frame.size.height / 2.5
        
        // 2do
        // check and return minimum sizes
        
        return CGSizeMake(picDimensionX, picDimensionY)
    }
    
    // aussenabstand des grids
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0 // 14.0
        // return UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            viewDidLoad()
        } else {
            viewDidLoad()
        }
    }
    

}