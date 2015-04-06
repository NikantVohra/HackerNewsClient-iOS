//
//  StoriesViewController.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 27/03/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//

import UIKit


class StoriesViewController: UITableViewController,MenuViewControllerDelegate,StoryTableViewCellDelegate,LoginViewControllerDelegate {
    
    var isFirstTime = true
    var section = PostFilterType.Top
    let transitionManager = TransitionManager()
    var currentPostType: PostFilterType = PostFilterType.Top
    let HNDidLoginOrOutNotification = "DidLoginOrOut"
    var shouldLoadNewPosts = true
    var nextPageUrlAddition: String? = nil
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    struct Constants {
        static var StoriesLimit = 10
    }
    
    var stories: [HNPost] = [] {
        didSet {
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        loadStories(section)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadStories:"), name: kHNShouldReloadDataFromConfiguration, object: nil);
        refreshControl?.addTarget(self, action: "refreshStories", forControlEvents: UIControlEvents.ValueChanged)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLoginButton", name: HNDidLoginOrOutNotification, object: nil)
        
        
    }
    

    
    @IBAction func didPressLoginButton(sender: AnyObject) {
        if(!HNManager.sharedManager().userIsLoggedIn()) {
            performSegueWithIdentifier("loginSegue", sender: self)
        }
        else {
            HNManager.sharedManager().logout()
            loginButton.title = "Login"
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    
    func setLoginButton() {
        if(HNManager.sharedManager().userIsLoggedIn()) {
            loginButton.title = "Logout"
        }
        else {
            loginButton.title = "Login"
        }
    }
    
    func loadStories(section : PostFilterType) {
        
        var completion: GetPostsCompletion = {[weak self](posts: [AnyObject]!, urlAddition: String!) -> Void in
            if let s = self {
                s.refreshControl?.endRefreshing()
                if let p = posts as? [HNPost] {
                    s.stories = (s.shouldLoadNewPosts ? p : s.stories + p)
                    s.view.hideLoading()
                    s.nextPageUrlAddition = urlAddition!
                    s.shouldLoadNewPosts = false
                }
            }
        }
        if(shouldLoadNewPosts) {
            HNManager.sharedManager().loadPostsWithFilter(section, completion:completion)
        }
        
        if (nextPageUrlAddition != nil && NSString(string: nextPageUrlAddition!).length > 0) {
            HNManager.sharedManager().loadPostsWithUrlAddition(nextPageUrlAddition!, completion: completion)
            return
        }
        

        
    }
    
 
    func refreshStories() {
        self.refreshControl?.beginRefreshing()
        loadStories(section)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as StoryCell
        let story = stories[indexPath.row]
        cell.configureWithStory(story)
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("webSegue", sender: indexPath)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var indexes = tableView.indexPathsForVisibleRows()
        if (indexes != nil && indexes?.count > 0) {
            let i = indexes![indexes!.count - 1] as NSIndexPath
            if (i.row == stories.count - 3 ) {
                loadStories(section)
            }
        }
    }

    
    func menuViewControllerDidTouchTop(controller: MenuViewController) {
        didSelectMenuOption(PostFilterType.Top)
        navigationItem.title = "Top Stories"
        
    }
    
    func menuViewControllerDidTouchRecent(controller: MenuViewController) {
        didSelectMenuOption(PostFilterType.New)
        navigationItem.title = "Recent Stories"
        
    }
    
    func menuViewControllerDidTouchShow(controller: MenuViewController) {
        didSelectMenuOption(PostFilterType.ShowHN)
        navigationItem.title = "Show HN"
        
    }
    
    func menuViewControllerDidTouchAsk(controller: MenuViewController) {
        didSelectMenuOption(PostFilterType.Ask)
        navigationItem.title = "Ask HN"
        
    }
    
    
    func didSelectMenuOption(newSection : PostFilterType) {
        view.showLoading()
        shouldLoadNewPosts = true
        nextPageUrlAddition = nil
        section = newSection
        nextPageUrlAddition = nil
        loadStories(section)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentsSegue" {
            let toView = segue.destinationViewController as CommentsViewController
            let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
            toView.story = stories[indexPath.row]
        }
        
        if segue.identifier == "menuSegue" {
            let toView = segue.destinationViewController as MenuViewController
            toView.delegate = self
        }
        
        if segue.identifier == "webSegue" {
            let toView = segue.destinationViewController as WebViewController
            let indexPath = sender as NSIndexPath
            let url = stories[indexPath.row].UrlString
            toView.url = url
            toView.story = stories[indexPath.row]
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            
            toView.transitioningDelegate = transitionManager
        }
        if segue.identifier == "loginSegue" {
            let toView = segue.destinationViewController as LoginViewController
            toView.delegate = self
        }

        if segue.identifier == "profileSegue" {
            let toView = segue.destinationViewController as UserProfileViewController
            let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
            toView.userName = stories[indexPath.row].Username
        }
    }
    
    // MARK: StoryTableViewCellDelegate
    
    func storyTableViewCellDidTouchUpvote(cell: StoryCell, sender: AnyObject) {
        if HNManager.sharedManager().userIsLoggedIn() {
            let indexPath = tableView.indexPathForCell(cell)!
            let story = stories[indexPath.row]
            HNManager.sharedManager().voteOnPostOrComment(story, direction: VoteDirection.Up, completion: { (success) -> Void in
                if(success) {
                    HNManager.sharedManager().addHNObjectToVotedOnDictionary(story, direction: VoteDirection.Up)
                    story.Points = story.Points + 1
                    cell.configureWithStory(story)
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
    
    func storyTableViewCellDidTouchComment(cell: StoryCell, sender: AnyObject) {
        performSegueWithIdentifier("commentsSegue", sender: cell)
    }

    
    func storyTableViewCellDidTouchAuthorLabel(cell: StoryCell, sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: cell)
    }
    // MARK: LoginViewControllerDelegate
    
    func loginViewControllerDidLogin(controller: LoginViewController) {
       // setLoginButton()
        
        
        view.showLoading()
        shouldLoadNewPosts = true
        nextPageUrlAddition = nil
        nextPageUrlAddition = nil
        loadStories(section)
    }
    
    
    func showAlert() {
        self.view.hideLoading()
        var alert = UIAlertController(title: "Oh noes.", message: "Something went wrong. The post wasn't upvoted.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
