//
//  MenuViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 27/03/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewControllerDidTouchTop(controller: MenuViewController)
    func menuViewControllerDidTouchRecent(controller: MenuViewController)
    func menuViewControllerDidTouchAsk(controller: MenuViewController)
    func menuViewControllerDidTouchShow(controller: MenuViewController)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuDialogView: DesignableView!
    weak var delegate: MenuViewControllerDelegate?

    
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        menuDialogView.animation = "fall"
        menuDialogView.animate()
    }
    
    @IBAction func topButtonDidTouch(sender: UIButton) {
        delegate?.menuViewControllerDidTouchTop(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func recentButtonDidTouch(sender: UIButton) {
        delegate?.menuViewControllerDidTouchRecent(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func askButtonDidTouch(sender: UIButton) {
        delegate?.menuViewControllerDidTouchAsk(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func showButtonDidTouch(sender: UIButton) {
        delegate?.menuViewControllerDidTouchShow(self)
        closeButtonDidTouch(sender)
    }
    
    
}
