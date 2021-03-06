//
//  DBViewController.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 18.03.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
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
        
        _ = DBHelper()
        print("DBHelper Class loaded")
        
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        let docsDir = dirPaths[0] 
        
        // let currentPath = docsDir
        // print(currentPath)
        // databasePath = docsDir.stringByAppendingPathComponent(currentPath+"/"+"database.db")
        databasePath = docsDir.NS.appendingPathComponent("database.db") as NSString
        
        if !filemgr.fileExists(atPath: databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
            
            if (contactDB?.open())! {
                
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !(contactDB?.executeStatements(sql_stmt))! {
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                contactDB?.close()
            } else {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
        
        // } else {
        //    print("DBViewController.swift: File not found")
        // }
        
        }
    }
    
    @IBAction func saveData(_ sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        print(#function + " in " + #file.NS.lastPathComponent)
        print("------------------------------------------------")
        print("-"+(databasePath as String)+"-")
        
        if (contactDB?.open())! {
            
            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(String(describing: name.text))', '\(String(describing: address.text))', '\(String(describing: phone.text))')"
            let result = contactDB?.executeUpdate(insertSQL,
                withArgumentsIn: nil)
            
            if !result! {
                status.text = "Failded to add to contact"
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            } else {
                status.text = "Contact added"
                name.text = ""
                address.text = ""
                phone.text = ""
            }
            contactDB?.close() //?
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
    }
    
    @IBAction func findContact(_ sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)
    
        if (contactDB?.open())! {
            let querySQL = "SELECT address, phone from CONTACTS where name = '\(String(describing: name.text))'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if results?.next() == true {
                address.text = results?.string(forColumn: "address")
                phone.text = results?.string(forColumn: "phone")
                status.text = "Record found"
            } else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            contactDB?.close()
        
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")

        }
        
    }
    

    @IBAction func findNews(_ sender: AnyObject) {
        
        _ = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        let docsDir = dirPaths[0] 
        
        // let currentPath = docsDir
        // print(currentPath)
        // databasePath = docsDir.stringByAppendingPathComponent(currentPath+"/"+"database.db")
        let dbPath = docsDir.NS.appendingPathComponent("bibservice.db")
        
        let myDB = FMDatabase(path: dbPath)
        
        if (myDB?.open())! {
            let querySQL = "SELECT id, news_id, description from News where id = 1"
            
            let results:FMResultSet? = myDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if results?.next() == true {
                news.text = results?.string(forColumn: "description")
            } else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            myDB?.close()
            
        } else {
            print("Error: \(String(describing: myDB?.lastErrorMessage()))")
            
        }
        
    }

    
}
