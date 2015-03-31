//
//  FeedPageViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 27/10/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//

import UIKit


class FeedPageViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var selectedFeedTitle = String()
    var selectedFeedFeedContent = String()
    var selectedFeedURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate Label
         textLabel.text = "title ... \(selectedFeedTitle)"
        // textView.text = "\(selectedFeedFeedContent)"

        // Config Text Area
        textView.editable = false
        // textView.contentInset = UIEdgeInsets(top: +60,left: 0,bottom: 0,right: 0)
       
        
        // Populate Text Area
        // Downcast (String -> NSString) for better String operations
        var formattedFeedFeedContent = selectedFeedFeedContent as NSString
        
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
        
        println("FeedPageDetail: "+outputStr)
        
        textView.text = "\(outputStr)"+" \(selectedFeedURL)"
*/
        var attributedHTMLFeedFeedContent = NSAttributedString(data: formattedFeedFeedContent.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)

        textView.attributedText = attributedHTMLFeedFeedContent
        
        
        // let myHTMLString:String! = "\(selectedFeedFeedContent)"
        // self.webView.loadHTMLString(myHTMLString, baseURL: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "openWebPage" {
            
            let fwpvc: FeedWebPageViewController = segue.destinationViewController as FeedWebPageViewController
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
