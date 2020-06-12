//
//  ViewController.swift
//  findway_ram_c0779370
//
//  Created by rschakar on 6/8/20.
//  Copyright © 2020 rs_chakar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate{
    var locationManager:CLLocationManager!
       var currentLocationStr = "Current location"
    var annotation = MKPointAnnotation()
   let destinationRequest = MKDirections.Request()
    
    @IBOutlet weak var doubleTap: UITapGestureRecognizer!

    @IBOutlet weak var pinch: UIPinchGestureRecognizer!
    @IBOutlet weak var findway: UIButton!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var transportBtn: UIButton!
    
    override func viewDidLoad() {
      super.viewDidLoad()
       
    
      
    }
    override func viewDidAppear(_ animated: Bool) {
           determineCurrentLocation()
      }
    
    
    @IBAction func pincAction(_ sender: UIPinchGestureRecognizer) {
        print("pinched")
        mapView.isZoomEnabled = true
        
}
    @IBAction func doubleTapAction(_ sender: UITapGestureRecognizer) {
          print("doublepress tap")
               mapView.isZoomEnabled = false
        let touchPoint = sender.location(in: mapView)
                   let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        //        let annotation = MKPointAnnotation()
                
                   annotation.coordinate = newCoordinates
                annotation.title = "Destination"
                annotation.subtitle = "Press Find Button to get Directions"
                   mapView.addAnnotation(annotation)
                mapView.removeAnnotations(mapView.annotations.filter { $0 !== mapView.userLocation })
             
                self.mapView.addAnnotation(annotation)
                print(newCoordinates,"Double Tap")
    }
 
    
    
 //Button for  User's Current Locaton.
    @IBAction func transportBtnAction(_ sender: UIButton) {
        print("your-loacation",locationManager.location!)

        yourLocation(_Location: locationManager.location!)

    }
    
    //Button action
    @IBAction func findwayaction(_ sender: UIButton) {
        
        print(annotation.coordinate,"Button")
               mapThis(destinationCord: annotation.coordinate)
      
        mapView.removeOverlays(mapView.overlays)
// destinationRequest.transportType = .automobile
               }
        
        
    
// function to get directions
    func mapThis(destinationCord : CLLocationCoordinate2D) {
      
        let souceCordinate = (locationManager.location?.coordinate)!
        
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        print(destItem,"destiantion placemark")
//        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        
        //Direction Part
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    print("Something is wrong :(")
                }
                return
            }
            
            
       //Route Part
          let route = response.routes[0]
            self.mapView.addOverlay(route.polyline,level: .aboveRoads)
          self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
        self.mapView.delegate = self
        
    }
    
    //To show Direction Route
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
          render.strokeColor = .red
          return render
      }
    
 
    
    
    
   

    
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
   
//function to get User Loacation
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
       
        mapView.delegate = self
        }
    
    
    
    
    
    
    func yourLocation(_Location: CLLocation){
        let location = locationManager.location!
             
                     let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
             var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan( latitudeDelta: 0.1, longitudeDelta: 0.1))
                     region.center = mapView.userLocation.coordinate
                     mapView.setRegion(region, animated: true)
    }

}

