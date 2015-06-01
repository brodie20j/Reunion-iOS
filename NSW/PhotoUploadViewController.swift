//
//  PhotoUploadViewController.swift
//  Carleton Reunion
//
//  Created by Jonathan Brodie on 5/31/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//

import UIKit

class PhotoUploadViewController: UIViewController {
    
    //This is a constant so we don't have some big ugly URL in the middle of the code
    let urlConstant: String="https://apps.carleton.edu/reunion/photos/submit/?module_identifier=mcla-carletonPhotoUploadModule-mloc-main_post-mpar-40cd750bba9870f18aada2478b24840a&module_api=standalone"
    
    @IBOutlet var photoWebView: UIWebView!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavigationColors()
        self.navigationItem.title = "Photo Upload"
        revealButtonItem.target = self.revealViewController()
        revealButtonItem.action = "revealToggle:"
        
        
        
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        var request = NSURLRequest(URL: NSURL(string: self.urlConstant)!)
        self.photoWebView.loadRequest(request)
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
