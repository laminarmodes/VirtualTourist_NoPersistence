//
//  Notebook.swift
//  VirtualTourist
//
//  Created by Anya Traille on 6/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class Pin {
    /// The name for the notebook
    //let name: String
    
    var latitude: Double
    var longitude: Double

    /// The date the notebook was created
    //let creationDate: Date

    /// The notes contained by the notebook
    var photos: [PhotoModel] = []

    init(latitude: Double, longitude: Double) {
        //self.name = name
        self.latitude = latitude
        self.longitude = longitude
        //creationDate = Date()
        photos = []
    }
}

extension Pin {
    /// Add a new note to the notebook
    func addPhotos() {
        photos.append(PhotoModel())
    }

    /// Removes the note at a specific index
    func removePhotos(at index: Int) {
        photos.remove(at: index)
    }
}
