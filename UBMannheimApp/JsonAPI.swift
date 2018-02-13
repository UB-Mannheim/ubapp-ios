//
//  JsonAPI.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 16.02.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//

import Foundation

// https://gist.github.com/Starefossen/689428b6c532d7fec0bb

class JsonAPI {
    
    /*
    func getData(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let url: NSURL = NSURL(string: "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json")!
        let ses = NSURLSession.sharedSession()
        let task = ses.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                return completionHandler(json["sections"] as [NSDictionary], nil)
            }
        })
        task.resume()
    }
    */
    
}
