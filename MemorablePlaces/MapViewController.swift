//
//  MapViewController.swift
//  MemorablePlaces
//
//  Created by user on 2/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!

    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation = locations[0]
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05

        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: coordinate, span: span)

        map.setRegion(region, animated: true)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gr:)))
        longPressRecognizer.minimumPressDuration = 2
        
        map.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func longPress(gr: UIGestureRecognizer){
        let touchPoint = gr.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        map.addAnnotation(annotation)
        
        
        
        if gr.state == UIGestureRecognizer.State.began {
            let touchPoint = gr.location(in: map)
            let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude,
                                                           longitude: newCoordinates.longitude),
                                                completionHandler: { (placemarks, error) -> Void in
                
                if error != nil {
                    print("ERROR in CLGeocoder: \(String(describing: error))")
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let pm = placemarks![0]
                    annotation.title = "\(pm.subThoroughfare ?? "no addr1") \(pm.thoroughfare ?? "no addr2")"
                    annotation.subtitle = "newly added place"
                    print(annotation.title as Any)
                    
                    self.map.addAnnotation(annotation)
                    
                } else {
                    annotation.title = "Unknown Place"
                    print("Problem with the data received from geocoder")
                    
                    self.map.addAnnotation(annotation)
                }
                                                    
            });
            
        }
    }


}
