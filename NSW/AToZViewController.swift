//
//  AToZViewController.swift
//  Carleton Reunion
//
//  Created by Alex Mathson on 6/6/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//

import UIKit

class AToZViewController: UIViewController {
    let urlConstant: String="https://apps.carleton.edu/reunion/a2z/"
    
    @IBOutlet var aToZWebView: UIWebView!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNavigationColors()
        self.navigationItem.title = "Reunion A to Z"
        revealButtonItem.target = self.revealViewController()
        revealButtonItem.action = "revealToggle:"
        
        
        
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
