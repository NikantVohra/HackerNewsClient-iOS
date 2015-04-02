//
//  ViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 27/03/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLogin(controller: LoginViewController)
}

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    @IBOutlet weak var emailImageView: SpringImageView!
    
    @IBOutlet weak var passwordImageView: SpringImageView!
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func classButtonDidTouch(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func didPressLoginButton(sender: AnyObject) {
        view.showLoading()
        
        HNManager.sharedManager().loginWithUsername(emailTextField.text, password: passwordTextField.text) {
            [weak self](user) -> Void in
            if (user != nil) {
                print(user.Karma)
                self!.dismissViewControllerAnimated(true, completion: nil)
                self!.delegate?.loginViewControllerDidLogin(self!)
                self!.view.hideLoading()
            }
            else {
                self!.dialogView.animation = "shake"
                self!.dialogView.animate()
                self!.view.hideLoading()
            }

        }
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField {
            emailImageView.image = UIImage(named: "icon-mail-active")
            emailImageView.animate()
        } else {
            emailImageView.image = UIImage(named: "icon-mail")
        }
        
        if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-password-active")
            passwordImageView.animate()
        } else {
            passwordImageView.image = UIImage(named: "icon-password")
        }
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
    }

}

