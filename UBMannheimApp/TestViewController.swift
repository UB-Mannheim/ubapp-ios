//
//  TestViewController.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 12.02.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, NSURLConnectionDelegate {

    /* 

    Deactivated because of errors in Swift 2 and not used

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var data = NSMutableData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Versuch 1
        // http://stackoverflow.com/questions/24065536/downloading-and-parsing-json-in-swift
        
        // Versuch 2
        // http://www.ioscreator.com/tutorials/json-parsing-tutorial-ios8-swift
        
        // let urlAsString = "http://date.jsontest.com"
        let urlAsString = "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json"
        
        // 1
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        //2
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error.localizedDescription)
            }
            var err: NSError?
            
            // 3
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }

            let json = JSON(jsonResult)
            
            // 4
            let name = json["sections"]["ic"]["name"].string
            let perc = json["sections"]["ic"]["percent"].stringValue
            //With a string from JSON supposed to an Dictionary
            let date = json["date"].stringValue
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dateLabel.text = name
                self.timeLabel.text = perc
            })
        })
        // 5
        jsonQuery.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // override func viewWillAppear(animated: Bool) {
    // super.viewWillAppear(animated)
    // startConnection()
    // }
    
    
    // func startConnection(){
    //     let urlPath: String = "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json"
    //     var url: NSURL = NSURL(string: urlPath)!
    //     var request: NSURLRequest = NSURLRequest(URL: url)
    //     var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
    //     connection.start()
    // }
    
    // func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
    //     self.data.appendData(data)
    // }
    
    // func buttonAction(sender: UIButton!){
    //     startConnection()
    // }
    
    // func connectionDidFinishLoading(connection: NSURLConnection!) {
    //     var err: NSError
        // // throwing an error on the line below (can't figure out where the error message is)
    //  var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    //     print(jsonResult)
        
        // var labelString = jsonResult["date"] as String
        
    }
//
    */
}
