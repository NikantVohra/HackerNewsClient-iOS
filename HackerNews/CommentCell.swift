//
//  CommentCell.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 30/03/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit



class CommentCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: AsyncImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var upvoreButton: SpringButton!
    
    @IBOutlet weak var commentTextView: AutoTextView!
    @IBOutlet weak var replyButton: SpringButton!
    
    @IBOutlet weak var indentView: UIView!
    @IBOutlet weak var avatarLeftConstraint: NSLayoutConstraint!
    
    weak var delegate: CommentTableViewCellDelegate?

    func configureWithComment(comment: HNComment?) {
        let userDisplayName = comment!.Username
        let createdAt = comment!.TimeCreatedString
        let bodyHTML = comment!.Text
        authorLabel.text = userDisplayName
        timeLabel.text = createdAt

        commentTextView.text = bodyHTML

        
        let depth = comment!.Level > 4 ? 4 : comment!.Level
        if depth > 0 {
            avatarLeftConstraint.constant = CGFloat(depth) * 20 + 25
            separatorInset = UIEdgeInsets(top: 0, left: CGFloat(depth) * 20 + 15, bottom: 0, right: 0)
            indentView.hidden = false
        } else {
            avatarLeftConstraint.constant = 10
            separatorInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
            indentView.hidden = true
        }
        if (HNManager.sharedManager().hasVotedOnObject(comment)) {
            upvoreButton.imageView?.image = UIImage(named: "icon-upvote-active")
        }
        else {
            upvoreButton.imageView?.image = UIImage(named: "icon-upvote")
        }
    }
    
    @IBAction func didTouchUpvoteButton(sender: AnyObject) {
        delegate?.commentTableViewCellDidTouchUpvote(self)
        upvoreButton.animation = "pop"
        upvoreButton.force = 3
        upvoreButton.animate()

    }
    
    @IBAction func didTouchReplyButton(sender: AnyObject) {
        delegate?.commentTableViewCellDidTouchComment(self)
        replyButton.animation = "pop"
        replyButton.force = 3
        replyButton.animate()
    }
}


protocol CommentTableViewCellDelegate: class {
    func commentTableViewCellDidTouchUpvote(cell: CommentCell)
    func commentTableViewCellDidTouchComment(cell: CommentCell)
}
