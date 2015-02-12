//
//  TestViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 12.02.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, NSURLConnectionDelegate {

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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startConnection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startConnection(){
        let urlPath: String = "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func buttonAction(sender: UIButton!){
        startConnection()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        println(jsonResult)
        
    }
    

}
