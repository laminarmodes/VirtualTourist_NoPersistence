//
//  PhotoParser.swift
//  VirtualTourist
//
//  Created by Anya Traille on 4/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct PhotoParser: Codable
{
    let photos: Photos
    let stat: String
    
    enum CodingKeys: String, CodingKey
    {
        case photos
        case stat
    }
}
