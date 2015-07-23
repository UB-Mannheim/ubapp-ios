//
//  FeedPageViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 27/10/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//

import UIKit


class FeedPageViewController: UIViewController {

    var DEBUG: Bool = false
    // if (DEBUG) {
    
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
        // --> LabelView around Label ... :)
        
        // textView.text = "\(selectedFeedFeedContent)"

        // Config Text Area
        // textView.editable = false
        // textView.contentInset = UIEdgeInsets(top: +60,left: 0,bottom: 0,right: 0)
       
        
        // Populate Text Area
        // Downcast (String -> NSString) for better String operations
        var formattedFeedFeedContent = selectedFeedFeedContent as NSString
        
        // if (DEBUG) { println(formattedFeedFeedContent) }
        
        // 2DOs
        // ggf nach <img> IMMER ein <br/>
        // ueberfluessige zeichen an anfang und ende abschneiden
        
/*
        var endOfStrPos = formattedFeedFeedContent.rangeOfString("<a").location
        // endOfStrPos = formattedFeedFeedContent.length
        
        // Cast backwards (NSString->String)
        var outputStr = formattedFeedFeedContent.substringToIndex(endOfStrPos) as String
        // and get rid of unwanted utf-8 xml chars
        // 124, 8230
        
        // outputStr.substringFromIndex(advance(outputStr.startIndex,7))
        
        outputStr = outputStr.stringByReplacingOccurrencesOfString("&#124;", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        outputStr = outputStr.stringByReplacingOccurrencesOfString("&#8230;", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        outputStr = outputStr.stringByReplacingOccurrencesOfString("&#160;", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        outputStr = outputStr.stringByReplacingOccurrencesOfString("&#62;", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        // outputStr = outputStr.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        // strip whitespaces in between
        outputStr = outputStr.stringByReplacingOccurrencesOfString("  ", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        outputStr = outputStr.stringByReplacingOccurrencesOfString("   ", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        outputStr = outputStr.stringByReplacingOccurrencesOfString("    ", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        outputStr = outputStr.stringByReplacingOccurrencesOfString("     ", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        // strip whitespaces and linebreaks beginning and end
        outputStr = outputStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (DEBUG) { println("FeedPageDetail: "+outputStr) }
        
        textView.text = "\(outputStr)"+" \(selectedFeedURL)"
*/
        
        // Variration with AttributedText
        /*
        var attributedHTMLFeedFeedContent = NSAttributedString(data: formattedFeedFeedContent.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)

        textView.attributedText = attributedHTMLFeedFeedContent
        */
        
        var html_prefix = "<html><head><title>News</title><style type=\"text/css\">body { font-family:Helvetica; } a { font-family:Helvetica; font-weight: bold; color: #990000; text-decoration:none; } img { width: 90%; height: auto; margin-bottom: 1em; display:block; }</style><body>"
        var html_suffix = "</body></html>"
        
        var html = html_prefix + selectedFeedFeedContent + html_suffix
        webView.loadHTMLString(html, baseURL: nil)
        
        // if (DEBUG) { println(html) }
        
        /*
        var textAttachment: NSTextAttachment = NSTextAttachment();
        textAttachment.image = UIImage(named: "website");
        var rects: CGRect = textAttachment.bounds;
        rects.size.height = 33;
        rects.size.width = 100;
        */
        
        // textView.attributedText.setValue(value: nil, forKey: "NSAttachment")
        
        // if (DEBUG) { println(attributedHTMLFeedFeedContent) }
        
        
        // CHANGE Attributed Text Contents
        // http://stackoverflow.com/questions/29543312/export-image-from-attributed-text-in-swift
        
        // let myHTMLString:String! = "\(selectedFeedFeedContent)"
        // self.webView.loadHTMLString(myHTMLString, baseURL: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "openWebPage" {
            
            let fwpvc: FeedWebPageViewController = segue.destinationViewController as! FeedWebPageViewController
            selectedFeedURL =  selectedFeedURL.stringByReplacingOccurrencesOfString(" ", withString:"")
            selectedFeedURL =  selectedFeedURL.stringByReplacingOccurrencesOfString("\n", withString:"")
            fwpvc.feedURL = selectedFeedURL
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
