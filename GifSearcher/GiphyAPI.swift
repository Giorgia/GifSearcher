//
//  GiphyAPI.swift
//  GifSearcher
//
//  Created by Giorgia Marenda on 10/23/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import Foundation

import Alamofire

/**
 Convinience way to contruct the URLRequest
 */
public enum Router: URLRequestConvertible {
    
    static let baseURLString = "http://api.giphy.com"
    
    case Search(String)
    case TrendingGifs()
    
    var method: Alamofire.Method {
        switch self {
        case .Search,
        .TrendingGifs:
            return .GET
        }
    }
    
    public var path: String {
        switch self {
        case .TrendingGifs:
            return "/v1/gifs/trending"
        case .Search:
            return "/v1/gifs/search"
        }
    }
    
    public var parameters: [String: AnyObject] {
        
        var apiKey: [String : AnyObject] {
            return ["api_key" : "dc6zaTOxFJmzC"]
        }
        
        switch self {
        case .Search(let query):
            return ["q": query] + apiKey
        default:
            return apiKey
        }
    }
    
    // MARK: URLRequestConvertible
    
    public var URLRequest: NSMutableURLRequest {
        let URL                         = NSURL(string: Router.baseURLString)!
        let mutableURLRequest           = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod    = method.rawValue
        
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
    }
}


class GiphyAPI {
    /**
     Performs the GET request for Trending GIFs API
     */
    class func trendingGIFs(complention: ([Gif]?, ErrorType?) -> Void) {
        Alamofire.request(Router.TrendingGifs())
            .responseArray("data", completionHandler: complention)
    }
    
    /**
     Performs the GET request for Search API
     */
    class func search(query: String, complention: ([Gif]?, ErrorType?) -> Void) {
        Alamofire.request(Router.Search(query))
            .responseArray("data", completionHandler: complention)
        }
}