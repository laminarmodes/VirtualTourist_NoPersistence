//
//  PinViewController.swift
//  VirtualTourist
//
//  Created by Anya Traille on 6/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var pins: [Pin] = []
    var selectedLatitude = 1.3521
    var selectedLongitude = 103.8198
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var coordinateDisplay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotateMap()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print("Coordinates from addAnnotationOnLongPress are \(coordinate)")
            
            //Now use this coordinate to add annotation on map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            // To Do: Set Title
            annotation.title = "Title"
            annotation.subtitle = "subtitle"
            self.mapView.addAnnotation(annotation)
            
            // now create pin model
            let pin = Pin(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            // append it to set of pins
            pins.append(pin)
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let location = locations.last! as CLLocation
//
//        //        let pinLatitude = location.coordinate.latitude
//        //        let pinLongitude = location.coordinate.longitude
//        //
//        //        // Create a new pin
//        //        let pin = Pin(latitude: pinLatitude, longitude: pinLongitude)
//        //        pins.append(pin)
//
//        print("Coordinates from location manager are \(location.coordinate)")
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1.1, longitudeDelta: 1.1))
//
//        mapView.setRegion(region, animated: true)
//        annotateMap()
//    }
    
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
    
    func pin(at indexPath: IndexPath) -> Pin {
        return pins[indexPath.row]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let secondControllerTakeData = segue.destination as! PhotoViewController
        
        secondControllerTakeData.selectedLatitude = selectedLatitude
        secondControllerTakeData.selectedLongitude = selectedLongitude
        
        
        //secondControllerTakeData.pins = self.pins
        //let indexPath = ?
        // the pin of the next controller needs to be the pin that was selected
        // secondControllerTakeData.pin = pin(at: indexPath)
        //secondControllerTakeData.pin = pins[1]
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var selectedPin: MKPointAnnotation!
        selectedPin = view.annotation as? MKPointAnnotation
        selectedLatitude  = selectedPin.coordinate.latitude
        selectedLongitude = selectedPin.coordinate.longitude
        performSegue(withIdentifier: "ToPhotoViewController", sender: self)
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
    
    
}
