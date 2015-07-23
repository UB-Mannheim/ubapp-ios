
//
//  WebViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var DEBUG: Bool = false
    
    //Toolbar Icons
    // Iconbeast
    // http://www.iconbeast.com/free/
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    // Fallback
    var website:NSString = "http://www.google.de"
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        /*
            let requestURL = NSURL(string: website)
            let request = NSURLRequest(URL: requestURL!)
            webView.loadRequest(request)
        */
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (DEBUG) { println("DEBUG MSG WebViewController_ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
        
        if(self.website.containsString("primo.bib.uni-mannheim.de")) {
            self.title = "Primo"
        }
        
        if(self.website.containsString("www.bib.uni-mannheim.de")) {
            self.title = "Website"
        }
        
        if IJReachability.isConnectedToNetwork() {
        
            // check if necessary and why
            // let webView:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
            webView.loadRequest(NSURLRequest(URL: NSURL(string: self.website as String)!))
            webView.delegate = self
            // check if necessary and why
            // self.view.addSubview(webView)
           
        } else {
            
            let url = NSBundle.mainBundle().URLForResource("offline", withExtension:"html")
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            webView.delegate = self
            
            returnNetworkError("Keine Verbindung zum Netzwerk vorhanden")
            
            // #1
            /* 
            
            ausgelagert in eigene Funktion
            
            let alertController = UIAlertController(title: "Fehler", message: "Keine Verbindung zum Netzwerk vorhanden", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Zurück", style: .Cancel) { (action) in
                
                self.userDefaults.setObject(1, forKey: "backFromWebview")
                
                // creating a new controller?
                // MainView set as storyboard ID of MainViewController
                // let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as! MainViewController
                let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
                self.navigationController?.pushViewController(homeViewController, animated: true)
                
                // #2 running a available controller
                
                // so you don't have to use this
                // let firstRunReference = 0
                // self.userDefaults.setObject(firstRunReference, forKey: "firstRun")
                
                
            }
            
            let okAction = UIAlertAction(title: "Neu laden", style: .Default) { (action) in
                self.viewDidLoad()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            // UINavigationController(rootViewController: WebViewController())
            
            */
        }
        
        if (DEBUG) { println("didLoad") }

   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if (DEBUG) { println("didReceiveMemoryWarning") }
    }
    
    
    /*
        // // // // // // // // // // // // // // // // // // // // // // // // //
    
        Circular ProgressBar (Upper right in NavigationBar)
    */
    
    // show circular progress activity in upper navigation bar
    // -start()
    //  call: self.webViewDidStartLoad(webView)
    
    func webViewDidStartLoad(webView: UIWebView) { //start
        // print("Webview started Loading")
        
        // Centered Activity Bar
        // stackoverflow.com/questions/72388711/activity-picker-forweb-view-in-swift
        
        // special color and black frame
        // coderwall.com/p/su1ta/ios-customized-activity-indicator-with-swift
        activity.hidden = false
        activity.startAnimating()
        
        // Activity Bar in Top Bar
        var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        var activityBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = activityBarButtonItem
        activityIndicator.startAnimating()
        
        // print("Webview started Loading")
    }
    
    // show circular progress activity in upper navigation bar
    // -stop()
    //  call: self.webViewDidFinishLoad(webView)
    
    func webViewDidFinishLoad(webView: UIWebView) { //stop
        // print("Webview did finish load")
        
        activity.hidden = true
        activity.stopAnimating()
        
        navigationItem.rightBarButtonItem = nil
        
        /*
        var js: String = "var script = document.createElement('script');" +
        "script.type = 'text/javascript';" +
        "script.text = \"function myFunction() { " +
        // "var field = document.getElementById('field_3');" +
        //"field.value='Calling function - OK';" +
        "alert('Hello');" +
        "}\";" +
        "document.getElementsByTagName('head')[0].appendChild(script);"
        */
        
        var www_js:String = "document.getElementById('mobile_trailer').style.backgroundColor = 'white'; " + 
        "document.getElementById('mobile_trailer').style.transition = 'background-color 1000ms linear'; "
        
        var primo_js:String = "document.getElementById('exlidUserAreaTile').style.padding = '10px'; " +
            "document.getElementById('logos').style.visibility = 'hidden'; " +
            "document.getElementById('exlidSearchTile').style.position = 'relative'; " +
            "document.getElementById('exlidSearchTile').style.top = '-80px'; " +
            "document.getElementById('exlidMainMenuRibbon').style.display = 'none'; " +
            "document.getElementById('exlidHeaderContainer').style.height = '100px'; "
            
            
        self.webView.stringByEvaluatingJavaScriptFromString(primo_js)
        // self.webView.stringByEvaluatingJavaScriptFromString("myFunction();")
        
        self.webView.stringByEvaluatingJavaScriptFromString(www_js)
        
        if (DEBUG) { println("didFinishLoad") }
        
    }

    
    
    /*
        // // // // // // // // // // // // // // // // // // // // // // // // //
    
        UIWebView Delegate Functions, requirement: extend class with <UIWebViewDelegate>
    */
    
    // webview error
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        print("Webview fail with error \(error)");
    }
    
    // webview request
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if( (navigationType == UIWebViewNavigationType.LinkClicked) && (IJReachability.isConnectedToNetwork() == false) ) {
            if (DEBUG) { println("tapped") }
            
            returnNetworkError("Verbindung zum Netzwerk unterbrochen")
                
        }
        
    return true;
    }
    
    // webview start loading
    
    /* func webViewDidStartLoad(webView: UIWebView!) {
        // print("Webview started Loading")
        
         webViewDidStartLoad(self.webView)
    } */
    
    // webview finished loading
    
    /* func webViewDidFinishLoad(webView: UIWebView!) {
        // print("Webview did finish load")
        
        webViewDidFinishLoad(self.webView)
        
        // let myjsaction = self.webView.stringByEvaluatingJavaScriptFromString("alert(document.documentElement.innerHTML);")
        
        // #3
    
        /*
        var js: String = "var script = document.createElement('script');" +
        "script.type = 'text/javascript';" +
        "script.text = \"function myFunction() { " +
        // "var field = document.getElementById('field_3');" +
        //"field.value='Calling function - OK';" +
        "alert('Hello');" +
        "}\";" +
        "document.getElementsByTagName('head')[0].appendChild(script);"
        
        self.webView.stringByEvaluatingJavaScriptFromString("document.write('this works')")
        self.webView.stringByEvaluatingJavaScriptFromString("myFunction();")
        */
    }*/
    
    
    
    
    // no more longer used
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    // end

    @IBAction func back(sender: UIBarButtonItem) {
        if (IJReachability.isConnectedToNetwork()) {
            if (self.webView.canGoBack) {
                self.webView.goBack()
            }
        } else {
            returnNetworkError("Keine Verbindung zum Netzwerk vorhanden")
        }
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        if (IJReachability.isConnectedToNetwork()) {
            if (self.webView.canGoForward) {
                self.webView.goForward()
            }
        } else {
            returnNetworkError("Keine Verbindung zum Netzwerk vorhanden")
        }
    }
    
    @IBAction func home(sender: UIBarButtonItem) {
        // self.webView.stopLoading()
        // let requestURL = NSURL(string: "http://www.bib.uni-mannheim.de/mobile")
        
        var homeStr = "http://www.bib.uni-mannheim.de/mobile"
        
        if(self.website.containsString("primo.bib.uni-mannheim.de")) {
            // if (DEBUG) { println("primo") }
            homeStr = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
        }
        
        let requestURL = NSURL(string: homeStr)
        
        if (IJReachability.isConnectedToNetwork()) {
            let request = NSURLRequest(URL: requestURL!)
            self.webView.loadRequest(request)
        } else {
            returnNetworkError("Keine Verbindung zum Netzwerk vorhanden")
        }
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        if (IJReachability.isConnectedToNetwork()) {
            self.webView.reload()
        } else {
            returnNetworkError("Keine Verbindung zum Netzwerk vorhanden")
        }
    }
    
    func returnNetworkError(error_msg: String) {
    
        let alertController = UIAlertController(title: "Fehler", message: error_msg, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Zurück", style: .Cancel) { (action) in
            
            self.userDefaults.setObject(1, forKey: "backFromWebview")
            
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
            self.navigationController?.pushViewController(homeViewController, animated: true)
            
        }
        
            let okAction = UIAlertAction(title: "Neu laden", style: .Default) { (action) in
            self.viewDidLoad()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

