//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 30/03/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {

    var story:HNPost? 
    var isFirstTime = true
    
    var comments:[HNComment]? = [] {
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments!.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifer = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as UITableViewCell
        
        if let storyCell = cell as? StoryCell {
            storyCell.configureWithStory(story)
        }
        
        if let commentCell = cell as? CommentCell {
            let comment = comments![indexPath.row - 1]
            commentCell.configureWithComment(comment)
        }
        
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
    
    
}
