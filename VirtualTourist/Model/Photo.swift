//
//  Photo.swift
//  VirtualTourist
//
//  Created by Anya Traille on 3/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

// This is the blueprint that describes the properties of a single photo.  There can be multiple photos so we can use a struct. Photo must conform to the protocol 'Decodable'
struct Photo: Codable {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey
    {
        // Must indicate all cases or will get an error that Photo does not conform to Protocol 'Decodable'
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case imageURL = "url_m"
        
    }

}




