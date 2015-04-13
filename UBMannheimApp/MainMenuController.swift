//
//  MainMenuController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 09.04.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class MainMenuController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // exkurs: tutorial adaptive layout
    // https://youtu.be/E3glNbNnokw
    
    
    // this.
    // http://www.brianjcoleman.com/tutorial-collection-view-using-swift/
    
    @IBOutlet var collectionView: UICollectionView!
    
    var menuItems: [MenuItem] = []
    
    /*
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var picDimensionX: CGFloat = 0.0
    var picDimensionY: CGFloat = 0.0
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuItems()
        
        /*
        var currentDevice: UIDevice = UIDevice.currentDevice()
        var orientation: UIDeviceOrientation = currentDevice.orientation
        println(orientation)
        */
        
        // http://stackoverflow.com/questions/25666269/ios8-swift-how-to-detect-orientation-change
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        rotated()
        /*
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 80, left: 20, bottom: 20, right: 20)
        let picDimensionX = self.view.frame.size.width / 2.5
        let picDimensionY = self.view.frame.size.height / 2.5
        
        layout.itemSize = CGSize(width: picDimensionX, height: picDimensionY)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        */
        
        // collectionView.reloadData() ?
    }
    
    func setLayout(myLayout: NSString) -> Void {
    
        var marginTop: CGFloat = 80
        
        if(myLayout.isEqualToString("landscape")) {
            
            marginTop = 40
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: marginTop, left: 20, bottom: 20, right: 20)
    
        let picDimensionX = self.view.frame.size.width / 2.5
        let picDimensionY = self.view.frame.size.height / 2.5
    
        layout.itemSize = CGSize(width: picDimensionX, height: picDimensionY)
    
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.collectionView!)
    
    }
    
    func rotated()
    {
        // println("rotate")
            
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            // println("landscape")
            setLayout("landscape")
        }
        if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            // println("portrait")
            setLayout("portrait")
        }
        
    }
    
    
    // func orientationChanged(notification: NSNotification) {
    //
    // } ?
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 20
        return menuItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as MyCollectionViewCell
        
        // cell.backgroundColor = UIColor.blackColor()
        // cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
        // cell.imageView?.image = UIImage(named: "website")
        
        cell.setMenuItem(menuItems[indexPath.row])
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    
}