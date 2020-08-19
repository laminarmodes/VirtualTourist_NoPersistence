//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Anya Traille on 3/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//
import Foundation
import UIKit
import MapKit

// Remember, to conform to the protocol must add the two collectionView functions.  These will be added in the extension
//class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
class PhotoViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var photoDataArray: [Photo] = []
    
    var pin: Pin!
    
    //var photoModel: PhotoModel!
    
    //var imageArray: [UIImage] = [] // not used?
    //var pinModel: PinModel!
    //var photos = [PhotoModel]()
    
    
    var selectedLatitude = 1.3521
    var selectedLongitude = 103.8198
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        annotateMap()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print("View is loading")
        print("*** Step 1: Calling VirtualTouristClient.getPhotoInfo and passing in handleRandomImageResponse(imageData:error:)")
        VirtualTouristClient.getPhotoInfo(latitude: selectedLatitude, longitude: selectedLongitude, completion: handleImageResponseAndAppendArray(imageData:error:))
        
        
    }
    
    func handleImageResponseAndAppendArray(imageData: [Photo], error: Error?)
    {
        print("Inside of handleRandomImageResponse(imageData: [Photo], error: Error?)")
        
        for singlePhotoData in imageData
        {
            print("the URL is \(String(singlePhotoData.imageURL))")
            
            // This will hold photo information
            self.photoDataArray.append(singlePhotoData)
            
            
            let imageURL = singlePhotoData.imageURL
            let imageURL2 = URL(string: imageURL)!
            
            
            VirtualTouristClient.downloadImageFile(url: imageURL2) { (data, error) in
               
                if let data = data
                {
                    
                    // How do I store/append this imageFile into my temporary model?
                }
            }

        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // Set up the Map View
    private func annotateMap()
    {
        mapView.delegate = self
        var annotationArray = [MKPointAnnotation]()
        let latitude = CLLocationDegrees(selectedLatitude)
        let longitude = CLLocationDegrees(selectedLongitude)
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "This is a test"
        annotation.subtitle = "of the map"
        
        annotationArray.append(annotation)
        
        self.mapView.addAnnotations(annotationArray)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    
    func generateLayout() -> UICollectionViewLayout {
      //1
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
      let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
      //2
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(2/3))
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitem: fullPhotoItem,
        count: 1)
      //3
      let section = NSCollectionLayoutSection(group: group)
      let layout = UICollectionViewCompositionalLayout(section: section)
      return layout
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // To do
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        //let image = imageArray[indexPath.row]
        let imageURL = photoDataArray[indexPath.row].imageURL
        let imageURL2 = URL(string: imageURL)!
        
        // VirtualTouristClient.downloadImageFile(url: imageURL2, completionHandler: self.handleImageFileResponse(image:error:))
        print("About to call VirtualTouristClient.downloadImageFile with completion handler")
        VirtualTouristClient.downloadImageFile(url: imageURL2) { (data, error) in
            print("inside closure of VirtualTouristClient.downloadImageFile")
            if let data = data
            {
                DispatchQueue.main.async {
                    cell.imageView.image = data
                }
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
        photoDataArray.remove(at: indexPath.row)
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
    
    @IBAction func cancel()
    {
        self.dismiss(animated: true, completion: nil)
    }
}




