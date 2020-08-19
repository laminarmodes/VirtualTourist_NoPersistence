//
//  PhotoModel.swift
//  VirtualTourist
//
//  Created by Anya Traille on 6/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class PhotoModel {
    
    var imageFile: UIImage
    
    init(imageFile: UIImage = UIImage(named: "download")!)
    //init(imageFile: String = "test")
    {
        self.imageFile = imageFile
    }
    
}


