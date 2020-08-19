//
//  Photos.swift
//  VirtualTourist
//
//  Created by Anya Traille on 3/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

// This is the blueprint that describes the properties of a photo set.  There can be multiple photo sets so we can use a struct. Photos must conform to the protocol 'Decodable'
struct Photos: Codable {

    let page: Int
    let pages: Int
    let perPage: Int
    let total: String
    let photo: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case total
        case photo
    } 
}
