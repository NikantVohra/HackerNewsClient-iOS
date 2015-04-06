//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 30/03/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController,ReplyViewControllerDelegate,StoryTableViewCellDelegate, CommentTableViewCellDelegate {

    var story:HNPost? 
    var isFirstTime = true
    var transitionManager = TransitionManager()
    
    var comments:[HNComment]! = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        loadCommments()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func reloadStory() {
        view.showLoading()
        self.loadCommments()
    }
    
    @IBAction func didPressShareButton(sender: AnyObject) {
        var title = story!.Title
        var url = story!.UrlString
        let activityViewController = UIActivityViewController(activityItems: [title, url], applicationActivities: nil)
        activityViewController.setValue(title, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments!.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifer = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as UITableViewCell
        
        if let storyCell = cell as? StoryCell {
            storyCell.configureWithStory(story)
            storyCell.delegate = self
        }
        
        if let commentCell = cell as? CommentCell {
            let comment = comments![indexPath.row - 1]
            commentCell.configureWithComment(comment)
            commentCell.delegate = self
        }
        refreshControl?.addTarget(self, action: "refreshComments", forControlEvents: UIControlEvents.ValueChanged)
        
        return cell
    }
    
    
    func loadCommments() {
        if (story != nil) {
            HNManager.sharedManager().loadCommentsFromPost(story, completion: {[weak self](comments) -> Void in
                if (comments != nil && self != nil) {
                    var s = self!
                    s.refreshControl?.endRefreshing()
                    s.comments = comments as? [HNComment]
                    s.view.hideLoading()
                }
            })
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "replySegue" {
            let toView = segue.destinationViewController as ReplyViewController
            if let cell = sender as? CommentCell {
                let indexPath = tableView.indexPathForCell(cell)!
                let comment = comments[indexPath.row - 1]
                toView.comment = comment
            }
            
            if let cell = sender as? StoryCell {
                toView.story = story
            }
            
            toView.delegate = self
            toView.transitioningDelegate = transitionManager
        }
        if segue.identifier == "profileSegue" {
            let toView = segue.destinationViewController as UserProfileViewController
            if let cell = sender as? CommentCell {
                let indexPath = tableView.indexPathForCell(cell)!
                let comment = comments[indexPath.row - 1]
                toView.userName = comment.Username
            }
            
            if let cell = sender as? StoryCell {
                toView.userName = story?.Username
            }
        }
    }
    
    // MARK: ReplyViewControllerDelegate
    
    func replyViewControllerDidSend(controller: ReplyViewController) {
        reloadStory()
    }
    
    // MARK: CommentTableViewCellDelegate
    
    func commentTableViewCellDidTouchUpvote(cell: CommentCell){
        if HNManager.sharedManager().userIsLoggedIn() {
            let indexPath = tableView.indexPathForCell(cell)!
            let comment = comments[indexPath.row]
            HNManager.sharedManager().voteOnPostOrComment(comment, direction: VoteDirection.Up, completion: { (success) -> Void in
                if(success) {
                    HNManager.sharedManager().addHNObjectToVotedOnDictionary(comment, direction: VoteDirection.Up)
                    cell.configureWithComment(comment)
                }
                else {
                    self.showAlert()
                }
            })
            cell.configureWithComment(comment)
        } else {
            performSegueWithIdentifier("loginSegue", sender: self)
        }

    }
    func commentTableViewCellDidTouchComment(cell: CommentCell){
        if !HNManager.sharedManager().userIsLoggedIn() {
            performSegueWithIdentifier("loginSegue", sender: cell)
        } else {
            performSegueWithIdentifier("replySegue", sender: cell)
        }
    }
    
    func commentTableViewCellDidTouchAuthorLabel(cell: CommentCell) {
        performSegueWithIdentifier("profileSegue", sender: cell)
    }
    // MARK: StoryTableViewCellDelegate
    
    func storyTableViewCellDidTouchUpvote(cell: StoryCell, sender: AnyObject) {
        if HNManager.sharedManager().userIsLoggedIn(){
            HNManager.sharedManager().voteOnPostOrComment(story, direction: VoteDirection.Up, completion: { (success) -> Void in
                if(success) {
                    HNManager.sharedManager().addHNObjectToVotedOnDictionary(self.story, direction: VoteDirection.Up)
                    self.story!.Points = self.story!.Points + 1
                    cell.configureWithStory(self.story!)
                }
                else {
                    self.showAlert()
                }
            })
            cell.configureWithStory(story)
        } else {
            performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    func  storyTableViewCellDidTouchAuthorLabel(cell: StoryCell, sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: cell)
    }
    
    func storyTableViewCellDidTouchComment(cell: StoryCell, sender: AnyObject) {
        if !HNManager.sharedManager().userIsLoggedIn() {
            performSegueWithIdentifier("loginSegue", sender: self)
        } else {
            performSegueWithIdentifier("replySegue", sender: cell)
        }
    }
    
    func refreshComments() {
        self.refreshControl?.beginRefreshing()
        loadCommments()
    }
    
    

    
    func showAlert() {
        self.view.hideLoading()
        var alert = UIAlertController(title: "Oh noes.", message: "Something went wrong. Your message wasn't sent. Try again and save your text just in case.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
