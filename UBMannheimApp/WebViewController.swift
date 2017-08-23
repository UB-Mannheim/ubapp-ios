//
//  WebViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15,
//  last modified on 22.03.16.
//
//  Copyright (c) 2015 Alexander Wagner, UB Mannheim. 
//  All rights reserved.
//
//
//  Toolbar Icons by Iconbeast
//  Source: http://www.iconbeast.com/free/
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var DEBUG: Bool = false
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    // Fallback URL (probably always reachable)
    var website:NSString = "http://www.google.de"
    
    let userDefaults:UserDefaults=UserDefaults.standard
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting Configuration Keys
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        
        if (DEBUG) {
            print("DEBUG MSG WebViewController_ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)")
        }
        
        // Initializing Language String Dictionary
        let dict = appDelegate.dict
        
        
        // Setting title according to Websites
        
        if(self.website.contains("primo.bib.uni-mannheim.de")) {
            self.title = "Primo"
        }
        
        if(self.website.contains("www.bib.uni-mannheim.de")) {
            self.title = "Website"
        }
        
        
        // Network Check
        
        if IJReachability.isConnectedToNetwork() {
        
            webView.loadRequest(URLRequest(url: URL(string: self.website as String)!))
            webView.delegate = self
            
        } else {
            
            let offlineError: String = (dict.object(forKey: "urls")! as AnyObject).object(forKey: "Offline") as! String
            let url = Bundle.main.url(forResource: offlineError, withExtension:"html")
            
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
            webView.delegate = self
            
            let alertMsg_Err_noNetwork: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Website")! as AnyObject).object(forKey: "noNetwork") as! String
            
            returnNetworkError(alertMsg_Err_noNetwork)
            
        }
        
        if (DEBUG) { print("didLoad") }

   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        if (DEBUG) { print("didReceiveMemoryWarning") }
    }
    
    
    /*
        // // // // // // // // // // // // // // // // // // // // // // // // //
    
        Circular ProgressBar (Upper right in NavigationBar)
    */
    
    // show circular progress activity in upper navigation bar
    // -start()
    //  call: self.webViewDidStartLoad(webView)
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        activity.isHidden = false
        activity.startAnimating()
        
        // Activity Bar in Top Bar
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        let activityBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = activityBarButtonItem
        activityIndicator.startAnimating()
        
    }
    
    // show circular progress activity in upper navigation bar
    // -stop()
    //  call: self.webViewDidFinishLoad(webView)
    
    func webViewDidFinishLoad(_ webView: UIWebView) { //stop
        
        activity.isHidden = true
        activity.stopAnimating()
        
        navigationItem.rightBarButtonItem = nil
        
        let www_js:String = "document.getElementById('mobile_trailer').style.backgroundColor = 'white'; " +
        "document.getElementById('mobile_trailer').style.transition = 'background-color 1000ms linear'; "
        
        let primo_js:String = "document.getElementById('exlidUserAreaTile').style.padding = '10px'; " +
            "document.getElementById('logos').style.visibility = 'hidden'; " +
            "document.getElementById('exlidSearchTile').style.position = 'relative'; " +
            "document.getElementById('exlidSearchTile').style.top = '-80px'; " +
            "document.getElementById('exlidMainMenuRibbon').style.display = 'none'; " +
            "document.getElementById('exlidHeaderContainer').style.height = '100px'; "
            
            
        self.webView.stringByEvaluatingJavaScript(from: primo_js)
        
        self.webView.stringByEvaluatingJavaScript(from: www_js)
        
        if (DEBUG) { print("didFinishLoad") }
        
    }

    
    
    /*
        // // // // // // // // // // // // // // // // // // // // // // // // //
    
        UIWebView Delegate Functions, requirement: extend class with <UIWebViewDelegate>
    */
    
    // Webview Error Handling
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Webview fail with error \(error)");
    }
    
    // Webview Request
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let dict = appDelegate.dict
        let alertMsg_Err_lostConnection: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Website")! as AnyObject).object(forKey: "lostConnection") as! String
        
        
        if( (navigationType == UIWebViewNavigationType.linkClicked) && (IJReachability.isConnectedToNetwork() == false) ) {
            if (DEBUG) { print("tapped") }
            
            returnNetworkError(alertMsg_Err_lostConnection)
            
        }
        
    return true;
    }

    // BarButton Back
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        let dict = appDelegate.dict
        let alertMsg_Err_noNetwork: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Website")! as AnyObject).object(forKey: "noNetwork") as! String
        
        if (IJReachability.isConnectedToNetwork()) {
            if (self.webView.canGoBack) {
                self.webView.goBack()
            }
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    // BarButton Forward
    @IBAction func forward(_ sender: UIBarButtonItem) {
        
        let dict = appDelegate.dict
        let alertMsg_Err_noNetwork: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Website")! as AnyObject).object(forKey: "noNetwork") as! String
        
        if (IJReachability.isConnectedToNetwork()) {
            if (self.webView.canGoForward) {
                self.webView.goForward()
            }
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    
    // BarButton Home
    @IBAction func home(_ sender: UIBarButtonItem) {
        // self.webView.stopLoading()
        // let requestURL = NSURL(string: "http://www.bib.uni-mannheim.de/mobile")
        
        let dict = appDelegate.dict
        let primo_url: String = (dict.object(forKey: "urls")! as AnyObject).object(forKey: "Primo") as! String
        let alertMsg_Err_noNetwork: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Website")! as AnyObject).object(forKey: "noNetwork") as! String
        
        var homeStr = (dict.object(forKey: "urls")! as AnyObject).object(forKey: "Website") as! String
        
        if(self.website.contains("primo.bib.uni-mannheim.de")) {
            
            homeStr = primo_url
            
        }
        
        let requestURL = URL(string: homeStr)
        
        if (IJReachability.isConnectedToNetwork()) {
            let request = URLRequest(url: requestURL!)
            self.webView.loadRequest(request)
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    // BarButton Reload
    @IBAction func reload(_ sender: UIBarButtonItem) {
        
        let dict = appDelegate.dict
        let alertMsg_Err_noNetwork: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Website")! as AnyObject).object(forKey: "noNetwork") as! String
        
        if (IJReachability.isConnectedToNetwork()) {
            self.webView.reload()
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    func returnNetworkError(_ error_msg: String) {
        
        let dict = appDelegate.dict
        let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
        let alertMsg_Back: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "cancelAction")! as! String
        let alertMsg_Reload: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "reloadAction")! as! String
        
        let alertController = UIAlertController(title: alertMsg_Error, message: error_msg, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: alertMsg_Back, style: .cancel) { (action) in
            
            self.userDefaults.set(1, forKey: "backFromWebview")
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
            self.navigationController?.pushViewController(homeViewController, animated: true)
            
        }
        
            let okAction = UIAlertAction(title: alertMsg_Reload, style: .default) { (action) in
            self.viewDidLoad()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

