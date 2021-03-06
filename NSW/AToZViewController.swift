//
//  AToZViewController.swift
//  Carleton Reunion
//
//  Created by Alex Mathson on 6/6/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//

import UIKit

class AToZViewController: UIViewController,UIWebViewDelegate {
    let urlConstant: String="https://apps.carleton.edu/reunion/a2z/"
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    @IBOutlet weak var aToZWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNavigationColors()
        self.navigationItem.title = "Reunion A to Z"
        revealButtonItem.target = self.revealViewController()
        revealButtonItem.action = "revealToggle:"
        

        
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.aToZWebView.delegate=self
        
        var request = NSURLRequest(URL: NSURL(string: self.urlConstant)!)
        self.aToZWebView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        print("Webview fail with error \(error)");
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType)->Bool {
        return true;
    }
    
    //Start and stop the ActivityIndicator
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

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
