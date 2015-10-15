//
//  DBViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 18.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit
import Foundation

public extension String {
    var NS: NSString { return (self as NSString) }
}


class DBViewController: UIViewController {
    
    // http://www.techotopia.com/index.php/An_Example_SQLite_based_iOS_8_Application_using_Swift_and_FMDB
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var news: UITextField!
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = DBHelper()
        print("DBHelper Class loaded")
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        
        // let currentPath = docsDir
        // print(currentPath)
        // databasePath = docsDir.stringByAppendingPathComponent(currentPath+"/"+"database.db")
        databasePath = docsDir.NS.stringByAppendingPathComponent("database.db")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        
        // } else {
        //    print("DBViewController.swift: File not found")
        // }
        
        }
    }
    
    @IBAction func saveData(sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        print(__FUNCTION__ + " in " + __FILE__.NS.lastPathComponent)
        print("------------------------------------------------")
        print("-"+(databasePath as String)+"-")
        
        if contactDB.open() {
            
            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(name.text)', '\(address.text)', '\(phone.text)')"
            let result = contactDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                status.text = "Failded to add to contact"
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact added"
                name.text = ""
                address.text = ""
                phone.text = ""
            }
            contactDB.close() //?
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }
    
    @IBAction func findContact(sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)
    
        if contactDB.open() {
            let querySQL = "SELECT address, phone from CONTACTS where name = '\(name.text)'"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                address.text = results?.stringForColumn("address")
                phone.text = results?.stringForColumn("phone")
                status.text = "Record found"
            } else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            contactDB.close()
        
        } else {
            print("Error: \(contactDB.lastErrorMessage())")

        }
        
    }
    

    @IBAction func findNews(sender: AnyObject) {
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        
        // let currentPath = docsDir
        // print(currentPath)
        // databasePath = docsDir.stringByAppendingPathComponent(currentPath+"/"+"database.db")
        var dbPath = docsDir.NS.stringByAppendingPathComponent("bibservice.db")
        
        let myDB = FMDatabase(path: dbPath)
        
        if myDB.open() {
            let querySQL = "SELECT id, news_id, description from News where id = 1"
            
            let results:FMResultSet? = myDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                news.text = results?.stringForColumn("description")
            } else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            myDB.close()
            
        } else {
            print("Error: \(myDB.lastErrorMessage())")
            
        }
        
    }

    
}