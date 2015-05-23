//
//  TwitterViewController.swift
//  Carleton Reunion
//
//  Created by Jonathan Brodie on 5/16/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//
//  View Controller for the Twitter feed

import UIKit
class TwitterViewController: UIViewController {

    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navigation bar
        self.setNavigationColors()
        self.navigationItem.title = "Twitter Feed"
        revealButtonItem.target = self.revealViewController()
        revealButtonItem.action = "revealToggle:"
        
        
        
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Do any additional setup after loading the view.
        
        var parser: ICSParser = ICSParser()
        
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
