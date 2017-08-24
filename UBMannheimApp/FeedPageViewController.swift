//
//  FeedPageViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 27/10/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//
//  Last modified by Alexander Wagner on 22.03.2016
//
//

import UIKit

class FeedPageViewController: UIViewController {

    var DEBUG: Bool = true
    
    @IBOutlet weak var textLabel: UILabel!
    // @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var webView: UIWebView!
    
    var selectedFeedTitle = String()
    var selectedFeedFeedContent = String()
    var selectedFeedURL = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Populate Label
        textLabel.text = selectedFeedTitle
        
        // Config Text Area
        // textView.text = "\(selectedFeedFeedContent)"
        // textView.editable = false
        // textView.contentInset = UIEdgeInsets(top: +60,left: 0,bottom: 0,right: 0)
       
        
        // Populate Text Area
        // Downcast (String -> NSString) for better String operations
        var formattedFeedFeedContent = selectedFeedFeedContent as NSString
        
        // if (DEBUG) { print(formattedFeedFeedContent) }
        
        // FixMe
        // ggf nach <img> IMMER ein <br/>
        // ueberfluessige zeichen an anfang und ende abschneiden
        
        // Variation with AttributedText
        /*
        var attributedHTMLFeedFeedContent = NSAttributedString(data: formattedFeedFeedContent.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)

        textView.attributedText = attributedHTMLFeedFeedContent
        */
        
        let html_prefix = "<html><head><title>News</title><style type=\"text/css\">body { font-family:Helvetica; } a { font-family:Helvetica; font-weight: bold; color: #990000; text-decoration:none; } img { width: 90%; height: auto; margin-bottom: 1em; display:block; }</style><body>"
        let html_suffix = "</body></html>"
        
        let html = html_prefix + selectedFeedFeedContent + html_suffix
        webView.loadHTMLString(html, baseURL: nil)
        
        if (DEBUG) { print(html) }
        
        /*
        // Additional Attachment
        var textAttachment: NSTextAttachment = NSTextAttachment();
        textAttachment.image = UIImage(named: "website");
        var rects: CGRect = textAttachment.bounds;
        rects.size.height = 33;
        rects.size.width = 100;
        */
        
        // textView.attributedText.setValue(value: nil, forKey: "NSAttachment")
        
        // if (DEBUG) { print(attributedHTMLFeedFeedContent) }
        
        
        // Change AttributedText Contents
        // let myHTMLString:String! = "\(selectedFeedFeedContent)"
        // self.webView.loadHTMLString(myHTMLString, baseURL: nil)
        
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "openWebPage" {
            
            let fwpvc: FeedWebPageViewController = segue.destination as! FeedWebPageViewController
            selectedFeedURL =  selectedFeedURL.replacingOccurrences(of: " ", with:"")
            selectedFeedURL =  selectedFeedURL.replacingOccurrences(of: "\n", with:"")
            fwpvc.feedURL = selectedFeedURL
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
