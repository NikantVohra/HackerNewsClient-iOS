//
//  ReplyViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 01/04/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit

protocol ReplyViewControllerDelegate: class {
    func replyViewControllerDidSend(controller: ReplyViewController)
}

class ReplyViewController : UIViewController {
    
    var story: HNPost?
    var comment: HNComment?
    weak var delegate: ReplyViewControllerDelegate?
    @IBOutlet weak var replyTextView: UITextView!
    
    @IBAction func didPressSendButton(sender: AnyObject) {
        view.showLoading()
        let body = replyTextView.text
        if story != nil {
            HNManager.sharedManager().replyToPostOrComment(story, withText: body, completion: { (success) -> Void in
                if(success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                }
                else {
                    self.showAlert()
                }
            })
        }
        
        else if comment != nil {
            HNManager.sharedManager().replyToPostOrComment(comment, withText: body, completion: { (success) -> Void in
                if(success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                }
                else {
                    self.showAlert()
                }
            })
        }
    }
    
    func showAlert() {
        self.view.hideLoading()
        var alert = UIAlertController(title: "Oh noes.", message: "Something went wrong. Your message wasn't sent. Try again and save your text just in case.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextView.becomeFirstResponder()
    }
}