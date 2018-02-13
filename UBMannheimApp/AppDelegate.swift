//
//  AppDelegate.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 27.01.15,
//  last modified on 22.03.16.
//
//  Copyright (c) 2015 Universitätsbibliothek Mannheim, UB Mannheim.
//  All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Language Settings
    var path = String()
    var dict = NSDictionary()
    var preferredLanguage = Locale.preferredLanguages[0] as String

    
    // Colors
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
    // Load Content (_en/_de)
    func loadContentInPreferredLanguage() {
        
        self.path = Bundle.main.path(forResource: "strings", ofType: "plist")!
        
        if (self.preferredLanguage.contains("de-")) {
            self.path = Bundle.main.path(forResource: "strings_de", ofType: "plist")!
        }
        
        self.dict = NSDictionary(contentsOfFile: path)!
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.tintColor = uicolorFromHex(0xffffff)
        navigationBarAppearance.barTintColor = uicolorFromHex(0x990000)
        
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. 
        // This can occur for certain types of temporary interruptions (such as an incoming phone call 
        // or SMS message) or when the user quits the application and it begins the transition to the 
        // background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. 
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough 
        // application state information to restore your application to its current state in case it is 
        // terminated later.
        // If your application supports background execution, this method is called instead of 
        // applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many 
        // of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. 
        // If the application was previously in the background, optionally refresh the user interface.
        
        // Loading Content in here
        self.loadContentInPreferredLanguage()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. 
        // See also applicationDidEnterBackground:.
    }


}

