//
//  PhotoUploadViewController.swift
//  Carleton Reunion
//
//  Created by Jonathan Brodie on 5/31/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//  Uses a Web View to display photo uploads.

import UIKit

class PhotoUploadViewController: UIViewController,UIWebViewDelegate {
    
    //This is a constant so we don't have some big ugly URL in the middle of the code
    let urlConstant: String="https://apps.carleton.edu/reunion/photos/submit/"
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var photoWebView: UIWebView!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNavigationColors()
        self.navigationItem.title = "Photo Upload"
        revealButtonItem.target = self.revealViewController()
        revealButtonItem.action = "revealToggle:"
        self.photoWebView.delegate=self
        self.activity.startAnimating()
        
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.getPhotoPage()

    }

    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        print("Webview fail with error \(error)");
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType)->Bool {
    return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        self.activity.startAnimating()
        self.activity.hidden=false
        print("Webview started Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        self.activity.stopAnimating()
        self.activity.hidden=true
        print("Webview did finish load")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getPhotoPage() {
        var request = NSURLRequest(URL: NSURL(string: self.urlConstant)!)
        self.photoWebView.loadRequest(request)
    }
    // Set navbar styling to consistent with rest of app
    func setNavigationColors() {
        var navBar: UINavigationBar = self.navigationController!.navigationBar
        navBar.translucent = false
        navBar.barTintColor = NSWStyle.oceanBlueColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: NSWStyle.whiteColor(),
            NSFontAttributeName: NSWStyle.boldFont()]
        var barBtnItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .Bordered, target: self, action: "popoverArrowDirection:")
        self.navigationItem.backBarButtonItem = revealButtonItem
        self.revealButtonItem.tintColor = NSWStyle.whiteColor()
 
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}



