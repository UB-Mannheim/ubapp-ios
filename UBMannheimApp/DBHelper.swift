//
//  DBHelper.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 24.03.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//

import Foundation

class DBHelper {
    
    // Demo Class with example Values from DBViewController (Contacts)
    
    // Database Version
    var DATABASE_VERSION: Int = 1
    // Database Name
    var DATABASE_NAME: String = "bibservice.db"
    
    // Table Names
    var TABLE_MODULES: String = "Modules"
    var TABLE_HISTORY: String = "History"
    var TABLE_LOAD: String = "Load"
    var TABLE_NEWS: String = "News"
    
    // Common column names
    var KEY_ID: String = "id"
    
    // Modules Table - column names
    var KEY_MODULES_NAME: String = "name"
    var KEY_MODULES_SAVE_MODE: String = "save_mode"
    
    // History Table - column names
    var KEY_HISTORY_MODULE_ID: String = "module_id"
    var KEY_HISTORY_LAST_UPDATE: String = "last_update"
    
    // Load Table - column names
    var KEY_LOAD_SECTOR: String = "sector"
    var KEY_LOAD_LOAD: String = "load"
    
    // News Table - column names
    var KEY_NEWS_TITLE: String = "news_id"
    var KEY_NEWS_DESCRIPTION: String = "description"
    var KEY_NEWS_URL: String = "url"
    var KEY_NEWS_POST_ID: String = "post_id"
    
    // SQL Strings
    var CREATE_TABLE_MODULES: String = ""
    var CREATE_TABLE_HISTORY: String = ""
    var CREATE_TABLE_LOAD: String = ""
    var CREATE_TABLE_NEWS: String = ""
    
    var INIT_DATABASE_MODULES_NEWS: String = ""
    var INIT_DATABASE_MODULES_LOAD: String = ""
    
    
    var mydatabasePath = NSString()
    
    init() {
        
        createSQLStatements()
        prepare()
        
        createNews()
        
    }
    
    func prepare() ->Void {
        
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] 
        
        self.mydatabasePath = docsDir.NS.appendingPathComponent("bibservice.db") as NSString
        
        if filemgr.fileExists(atPath: self.mydatabasePath as String) {
            
            let bibDB = FMDatabase(path: self.mydatabasePath as String)
            
            if bibDB == nil {
                print("Error: \(bibDB?.lastErrorMessage())")
            }
            
            if (bibDB?.open())! {
                
                // let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                
                let sql_statements =
                [
                    self.CREATE_TABLE_MODULES,
                    self.CREATE_TABLE_HISTORY,
                    self.CREATE_TABLE_LOAD,
                    self.CREATE_TABLE_NEWS,
                    self.INIT_DATABASE_MODULES_LOAD,
                    self.INIT_DATABASE_MODULES_NEWS
                ]
                
                for sql in sql_statements {
                    
                    // print(sql)
                    
                    if !(bibDB?.executeStatements(sql))! {
                        print("Error: \(bibDB?.lastErrorMessage())")
                    }
                    
                }
                
                bibDB?.close()
                
            } else {
                
                print("Error: \(bibDB?.lastErrorMessage())")
            }
            
        }
        
    }
    
    // Setup Table Create Statements and assign them to global variables
    func createSQLStatements() ->Void {
        
        // Module table create statement
        self.CREATE_TABLE_MODULES =
            "CREATE TABLE IF NOT EXISTS " + TABLE_MODULES +
            " (" +
            KEY_ID + " INTEGER PRIMARY KEY NOT NULL UNIQUE, " +
            KEY_MODULES_NAME + " VARCHAR(50), " +
            KEY_MODULES_SAVE_MODE + " INTEGER NOT NULL DEFAULT(1)" +
        ");"
        
        // History table create statement
        self.CREATE_TABLE_HISTORY =
            "CREATE TABLE IF NOT EXISTS " + TABLE_HISTORY +
            " (" +
            KEY_ID + " INTEGER PRIMARY KEY NOT NULL UNIQUE, " +
            KEY_HISTORY_MODULE_ID + " INTEGER REFERENCES Modules(id), " +
            KEY_HISTORY_LAST_UPDATE + " DATETIME" +
        ");"
        
        // Load table create statement
        self.CREATE_TABLE_LOAD =
            "CREATE TABLE IF NOT EXISTS " + TABLE_LOAD +
            " (" +
            KEY_ID + " INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, " +
            KEY_LOAD_SECTOR + " VARCHAR(100), " +
            KEY_LOAD_LOAD + " INTEGER" +
        ");"
        
        // News table create statement
        self.CREATE_TABLE_NEWS =
            "CREATE TABLE IF NOT EXISTS " + TABLE_NEWS +
            " (" +
            KEY_ID + " INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, " +
            KEY_NEWS_TITLE + " VARCHAR(100), " +
            KEY_NEWS_DESCRIPTION + " VARCHAR(255), " +
            KEY_NEWS_URL + " VARCHAR(100), " +
            KEY_NEWS_POST_ID + " INTEGER" +
        ");"
    /*
        // Initialize Modules
        self.INIT_DATABASE_MODULES_NEWS =
            "INSERT INTO " + TABLE_MODULES +
            " (" + KEY_ID + ", " + KEY_MODULES_NAME + ")" +
        " VALUES (1, 'News');";
        
        self.INIT_DATABASE_MODULES_LOAD =
            "INSERT INTO " + TABLE_MODULES +
            " (" + KEY_ID + ", " + KEY_MODULES_NAME + ")" +
        " VALUES (2, 'Load');";
    */
        
    }
    
    func createNews() ->Int {
        
        // get news
        let id = 1
        let title = "MyTitle"
        let desc = "Content of News entry ..."
        let url = "http://www.google.de"
        let post_id = 5236
        var newscount:Int32! = 0
        
        let db = FMDatabase(path: self.mydatabasePath as String)
        print(self.mydatabasePath)
        
        // get news latest news id
        if (db?.open())! {
            let querySQL = "SELECT count(*) from "+TABLE_NEWS
            
            let results:FMResultSet? = db?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if results?.next() == true {
                print("---")
                print(results?.int(forColumnIndex: 0))
                print("---")
                newscount = results?.int(forColumnIndex: 0)
            } else {
                print("Query returned emtpy result")
            }
            db?.close()
            
        } else {
            print("Error: \(db?.lastErrorMessage())")
            
        }
        
        let next_id = newscount + 1
        
        if (db?.open())! {
            
            // insert news
            let insertSQL = "INSERT INTO "+TABLE_NEWS+" ("+KEY_ID+", "+KEY_NEWS_TITLE+", "+KEY_NEWS_DESCRIPTION+", "+KEY_NEWS_URL+", "+KEY_NEWS_POST_ID+") VALUES ('\(next_id)', '\(title)', '\(desc)', '\(url)', '\(post_id)')"
            
            let result = db?.executeUpdate(insertSQL, withArgumentsIn: nil)
            print(result)
            
            if !result! {
                print("Failed to add to news")
                print("Error: \(db?.lastErrorMessage())")
            } else {
                print("Success: News added")
            }
            db?.close() //?
            
        } else {
            print("EEEE")
            print("Error: \(db?.lastErrorMessage())")
        }
        
        
        
        return id
        
    }
    
    
    
}
