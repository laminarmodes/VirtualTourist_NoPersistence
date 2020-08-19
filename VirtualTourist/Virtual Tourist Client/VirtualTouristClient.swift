//
//  VirtualTouristClient.swift
//  VirtualTourist
//
//  Created by Anya Traille on 3/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class VirtualTouristClient
{
    
    static let apiKey = "d03db70b0adbb654c42148032bb8972c"
    static let secret = "16c5737ec8e07631"
    //static let password = "uW9x;z9S(RHmF#g"
    
    enum Endpoints
    {
        
        static let baseURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&"
        static let apiURL = "api_key=\(VirtualTouristClient.apiKey)&"
        static let perPage = "per_page=3&"
        static let page = "&page=1"
        static let formatURL = "format=json"
        static let extras = "extras=url_m&"
        
        case searchImage(Double, Double)
        
        var stringValue: String
        {
            switch self
            {
                
            case .searchImage(let latitude, let longitude):
                return Endpoints.baseURL + Endpoints.apiURL + "&lat=\(latitude)&lon=\(longitude)" + Endpoints.page + Endpoints.perPage + Endpoints.extras + Endpoints.formatURL
            }
        }
        
        var url: URL
        {
            return URL(string: stringValue)!
        }
    }
    
    
    class func getPhotoInfo(latitude: Double, longitude: Double, completion: @escaping ([Photo], Error?) -> Void)
    {
        print("getPhotoInfo is being called")
        print("about to call taskForGetRequest")
        taskForGETRequest(url: Endpoints.searchImage(latitude, longitude).url, responseType: PhotoParser.self) { (response, error) in
            print("about to print the URL")
            print(Endpoints.searchImage(latitude, longitude).url)
            if let response = response {
                // Check photos.photo?
                print("this is the photo information from response.photos.photo")
                print(response.photos.photo)
                completion(response.photos.photo, nil)
            } else {
                print("no response, so nothing is being returned in getPhotoInfo")
                completion([], error)
            }
        }
    }
    
    
    // a class method because we don't needn an instance of the DogAPI to use it
    // UI Image and Error are optionals because if the download fails, then error is nil and if there is error, image will be nil and some kind of error
    class func downloadImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void)
    {
        print("requestImageFile is being called")
        // STEP 4: DOWNLOAD THE IMAGE DATA
        // Create URLSession data task to download the image
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data ,response, error) in
            guard let data = data else {
                // if error occurs, no image data returned so pass nil for image and error for the completion handler
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                
                print("data is nil")
                return
            }
            print("about to print the data...")
            print(data)
            //load data from the file.
            let downloadedImage = UIImage(data: data)
            // if successful, we have some image data to pass to view controller
            // so call completion handler here passing in downloaded image and nil for the error
            print("the downloaded image is being returned!")
            
            DispatchQueue.main.async {
                completionHandler(downloadedImage, nil)
            }
            
        })
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) //-> URLSessionTask
    {
        print("taskforGETRequest is being called")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else
            {
                print("error, session not working in taskforGetRequest")
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            print("about to print the data in taskforGetRequest")
            let decoder = JSONDecoder()
            
            // remove jsonFlickrApi( which has 14 characters
            let numChars = 14
            let range = (numChars..<data.count)
            var newData = data.subdata(in: range)
            // remove )
            _ = newData.popLast()
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                // There is a word called "jsonFlickrAPI({" before the "photos" struct constant and also a ")" at the end
                print("trying to decode responseObject in taskforGetRequest")
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async { completion(responseObject, nil) }
                
            } catch
            {
                print("could not decode response object in taskforGetRequest")
                
                do
                {
                    print("trying to decode error in taskforGetRequest")
                    let errorResponse = try decoder.decode(FailureResponse.self, from: newData)
                    DispatchQueue.main.async { completion(nil, errorResponse as? Error) }
                }
                catch
                {
                    print("could not decode error in taskforGetRequest")
                    DispatchQueue.main.async { completion(nil, error) }
                }
            }
        }
        task.resume()
        //return task
    }
    
}
