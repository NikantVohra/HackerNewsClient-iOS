//
//  UserProfileViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 03/04/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit

class UserProfileViewController : UIViewController {
    
    //@IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var contentView: UIView!
    var userName: String! = "jl"
    
  
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var karmaLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = ""
        self.karmaLabel.text = ""
        self.averageLabel.text = ""
        self.aboutLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.showLoading()
        HNService.getUser(userName, response: { (userJSON) -> () in
            self.view.hideLoading()
            self.nameLabel.text = userJSON["id"].string!
            self.karmaLabel.text = String(userJSON["karma"].int!);
            self.averageLabel.text = String(userJSON["karma"].int! / (userJSON["submitted"].count))
            self.aboutLabel.text = userJSON["about"].string!

        })
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    
    
    
    
    
}