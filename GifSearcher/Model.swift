//
//  Model.swift
//  GifSearcher
//
//  Created by Giorgia Marenda on 10/23/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class Gif: Mappable  {
    
    var id:     String?
    var type:   String?
    var url:    String?
    var images: [Image]?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        type    <- map["type"]
        url     <- map["url"]
        images  <- map["images"]
    }
}

class Image: Mappable  {
    
    var original:           Media?
    var fixedHeight:        Media?
    var fixedWidthSmall:    Media?
    var fixedHeightSmall:   Media?

    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        original        <- map["original"]
        fixedHeight     <- map["fixed_height"]
        fixedWidthSmall <- map["fixed_width_small"]
        fixedHeightSmall <- map["fixed_height_small"]
    }
}

class Media: Mappable  {
    
    var url:        String?
    var width:      Float?
    var height:     Float?
    var size:       Float?
    var mp4:        String?
    var mp4Size:    Int?
    var webp:       String?
    var webpSize:   Int?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        url         <- map["url"]
        width       <- map["width"]
        height      <- map["height"]
        size        <- map["size"]
        mp4         <- map["mp4"]
        mp4Size     <- map["mp4_size"]
        webp        <- map["webp"]
        webpSize    <- map["webp_size"]
    }
}