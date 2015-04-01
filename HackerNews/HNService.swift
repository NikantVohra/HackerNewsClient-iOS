//
//  HNService.swift
//  HackerNews
//
//  Created by Vohra, Nikant on 29/03/15.
//  Copyright (c) 2015 Vohra, Nikant. All rights reserved.
//
import Alamofire

struct HNService {
    
    private static let baseURL = "https://hacker-news.firebaseio.com"
    
    
    enum ResourcePath: Printable {
        case TopStories
        case NewStories
        case AskStories
        case ShowStories
        case ItemId(itemId: Int)

        
        var description: String {
            switch self {
            case .TopStories: return "/v0/topstories.json"
            case .NewStories: return "/v0/newstories.json"
            case .AskStories: return "/v0/askstories.json"
            case .ShowStories: return "/v0/showstories.json"
            case .ItemId(let id): return "/v0/item/\(id).json"
            
            }
        }
        
    }
    
    static func getItemWithId(itemID : Int, response: (JSON) -> ()) {
        let urlString = baseURL + ResourcePath.ItemId(itemId: itemID).description
        Alamofire.request(.GET, urlString, parameters: nil).responseJSON { (_, _, data, _) -> Void in
            let stories = JSON(data ?? [])
            response(stories)
        }

    }
    
    static func getCommentsOnStory(item:JSON,inout comments: [JSON!],inout maxComments : Int,limit : Int,response:([JSON!]) -> ()){
        var commentIds = item["kids"]
        println(item["id"])
        var count = commentIds.count
        if count == 0 || comments.count == maxComments {
            return
        }
        
        for var i = 0; i < count;i++ {
            let commentId :Int = commentIds[i].int!
            HNService.getItemWithId(commentId, response: { (responseJSON) -> () in
                
                //println(responseJSON)
                comments.append(responseJSON)
                println(comments.count)
                if(comments.count == maxComments) {
                    response(comments)
                    return
                }
                
                HNService.getCommentsOnStory(responseJSON, comments: &comments,maxComments : &maxComments,limit: limit, response)
                
                
            })
        }
    }
    
    static func getCommentsOnStory(item:JSON, limit : Int, response:([JSON!]) -> ()){
        
        var comments : [JSON!] = []
        var maxComments = item["descendants"].int!
        maxComments = maxComments < 20 ? maxComments : 5
        getCommentsOnStory(item, comments: &comments, maxComments: &maxComments, limit: limit) { (responseJSON) -> () in
            println(responseJSON)
            response(responseJSON)
        }
        
        
    }
    
    
    static func getStories(storyType: HNService.ResourcePath, limit : Int, response:([JSON!]) -> ()) {
        let urlString = baseURL + storyType.description
        Alamofire.request(.GET, urlString, parameters: nil).responseJSON { (_, _, data, _) -> Void in
            var stories:[JSON!] = []
            var storyIds:JSON! = JSON(data ?? [])
            let count = limit < storyIds.count ? limit : storyIds.count
            for var i = 0; i < count;i++ {
                let storyID :Int = storyIds[i].int!
                HNService.getItemWithId(storyID, response: { (responseJSON) -> () in
                    stories.append(responseJSON)
                    if(stories.count == count) {
                        var sortedStories = sorted(stories) {
                            HNService.findIndex(storyIds,element: $0["id"].int!)! < HNService.findIndex(storyIds,element: $1["id"].int!)!
                        }
                        response(sortedStories)
                    }
                })
            }
            
        }
    }
    
    
    static func findIndex(json :JSON!, element : Int) -> Int? {
        for var i = 0;i < json.count; i++ {
            if element == json[i].int? {
                return i
            }
            
        }
        return nil
    }
    

    
}