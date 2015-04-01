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
    func configureWithComment(comment: HNComment?) {
        let userDisplayName = comment!.Username
        let createdAt = comment!.TimeCreatedString
        let bodyHTML = comment!.Text
        authorLabel.text = userDisplayName
        timeLabel.text = createdAt
//        var html = bodyHTML + "<style>*{font-family:\"Avenir Next\";font-size:16px;line-height:20px}img{max-width:300px}</style>"
//        var attributedString = NSAttributedString(data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil, error: nil)
        commentTextView.text = bodyHTML
//        for link in comment!.Links {
//            commentTextView.addLinkToURL(link.Url, withRange: link.UrlRange)
//        }
        
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
    }
    
    
    
    
}
