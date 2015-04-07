//
//  PostViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 07/04/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit

class PostViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var urlTextField: DesignableTextField!
    @IBOutlet weak var titleTextField: DesignableTextField!
    
    @IBOutlet weak var textView: UITextView!{
        didSet {
            self.textView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.textView.layer.borderWidth = 1.0
            self.textView.layer.cornerRadius = 5
        }
        
    }
    
    
    @IBOutlet weak var done: UIBarButtonItem!
    
    @IBAction func done(sender: UIBarButtonItem) {
        let title = titleTextField.text
        let url = urlTextField.text
        let text = textView.text
        
        if title != nil && title != "" {
            view.showLoading()
            
            HNManager.sharedManager().submitPostWithTitle(title, link: url, text: text, completion: { (success) -> Void in
                self.view.hideLoading()
                if(success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    self.showAlert("Something went wrong. Your post wasn't sent. Try again and save your text just in case.")
                }
                
            })
        }
        else {
            self.showAlert("Please enter a valid title")
        }
        
        
    }
    func showAlert(message : String) {
        self.view.hideLoading()
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.becomeFirstResponder()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == self.titleTextField) {
            self.urlTextField.becomeFirstResponder()
        }
    }
    
}
    