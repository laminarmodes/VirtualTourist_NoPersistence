//
//  Error.swift
//  VirtualTourist
//
//  Created by Anya Traille on 3/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

// This is the blueprint that describes the properties of a FailureResponse.  There can be multiple copies of Failure Responses, so we can use a struct. Photo must conform to the protocol 'Decodable'

struct FailureResponse: Codable
{
    var status: String
    var code: Int
    var message: String
    
    enum Codingkeys: String, CodingKey{
        case status = "stat"
        case code
        case message
    }
}
