//
//  DBHelper.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 20.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import Foundation

class DBHelper {

    // Database Definition and Structure
    
    // Database Version
    var DATABASE_VERSION: integer_t = 1
    // Database Name
    var DATABASE_NAME: String = "bibservice"
    
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
    
    
    // Construct
    func DBHelper() {
        
    }
    
    // initializeData
    func initTables(db: String) ->Void {
    
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        
        var databasePath = docsDir.stringByAppendingPathComponent(db)
        
        if !filemgr.fileExistsAtPath(databasePath) {
            
            let db = FMDatabase(path: databasePath)
            
            if db == nil {
                println("Error: \(db.lastErrorMessage())")
            }
            
            if db.open() {
                
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
                    
                    if !db.executeStatements(sql) {
                        println("Error: \(db.lastErrorMessage())")
                    }
                    db.close()
                
                }
            } else {
                println("Error: \(db.lastErrorMessage())")
            }
        }
        
    }
    
    // Setup Table Create Statements
    func createTableStatements() ->Void{
        
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
        
        // Initialize Modules
        self.INIT_DATABASE_MODULES_NEWS =
            "INSERT INTO " + TABLE_MODULES +
            " (" + KEY_ID + ", " + KEY_MODULES_NAME + ")" +
            " VALUES (1, 'News');";
        
        self.INIT_DATABASE_MODULES_LOAD =
            "INSERT INTO " + TABLE_MODULES +
            " (" + KEY_ID + ", " + KEY_MODULES_NAME + ")" +
            " VALUES (2, 'Load');";
    
    }
    
    
}