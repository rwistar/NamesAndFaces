//
//  ViewController.swift
//  TwoWayCommunication
//
//  Created by Allie Shuldman 2016 on 3/1/16.
//  Copyright © 2016 Allie Shuldman. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var pageTitle: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var unfilterButton: UIButton!
    
    var browseURL = NSURL!()
    var urlToPassToSingle : NSURL!
    var hasBeenFiltered : Bool!
    var filterTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if browseURL == nil
        {
            browseURL = NSURL(string: "http://namesandfaces.hotchkiss.org/dbsamplequeryprogram.php")
            filterTitle = "Everyone"
        }
        
        let request = NSURLRequest(URL: browseURL!)
        webView.delegate = self
        webView.loadRequest(request)
        
        if hasBeenFiltered != nil && hasBeenFiltered == true
        {
            unfilterButton.hidden = false
        }
        else
        {
            unfilterButton.hidden = true
        }
        
        webView.scalesPageToFit = true
        
        pageTitle.title = filterTitle
        
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if (request.URL?.pathExtension == "jpg") || (request.URL == browseURL)
        {
            webView.scalesPageToFit = true
            return true
        }
        else
        {
            urlToPassToSingle = request.URL
            performSegueWithIdentifier("showSingleView", sender: self)
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showSingleView"
        {
            let destination = segue.destinationViewController as! SingleViewViewController
            destination.urlToLoad = urlToPassToSingle
        }
        
    }
    
    @IBAction func filterButtonPressed(sender: AnyObject) {
        
        if filterButton.title == "Unfilter"
        {
            browseURL = NSURL(string: "http://namesandfaces.hotchkiss.org/dbsamplequeryprogram.php")
            let request = NSURLRequest(URL: browseURL)
            webView.loadRequest(request)
            filterButton.title = "Filter"
        }
        else
        {
            performSegueWithIdentifier("goToFilterView", sender: self)
        }
        
    }
    
    
    @IBAction func unfilterButtonPressed(sender: AnyObject) {
        
        browseURL = NSURL(string: "http://namesandfaces.hotchkiss.org/dbsamplequeryprogram.php")
        let request = NSURLRequest(URL: browseURL)
        webView.loadRequest(request)
        filterButton.title = "Filter"
        hasBeenFiltered = false
        unfilterButton.hidden = true
        pageTitle.title = "Everyone"
        
    }
    
//    @IBAction func prepareToUnwind (segue: UIStoryboardSegue) {
//        
//        webView.scalesPageToFit = true
//    }
    



}

