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
   
    
    @IBOutlet weak var longpress: UILongPressGestureRecognizer!
    @IBOutlet weak var findway: UIButton!
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
       
    
      
    }
    override func viewDidAppear(_ animated: Bool) {
           determineCurrentLocation()
      }
    
    
    @IBAction func longpressaction(_ sender: UIGestureRecognizer) {
   let touchPoint = sender.location(in: mapView)
           let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
//        let annotation = MKPointAnnotation()
        
           annotation.coordinate = newCoordinates
        annotation.title = "Destination"
        annotation.subtitle = "Press Find Button to get Directions"
           mapView.addAnnotation(annotation)
        mapView.removeAnnotations(mapView.annotations.filter { $0 !== mapView.userLocation })
     
        self.mapView.addAnnotation(annotation)
        print(newCoordinates)
    }
    
    
    //Button action
    @IBAction func findwayaction(_ sender: UIButton) {
        
        print(annotation.coordinate,"Button")
               mapThis(destinationCord: annotation.coordinate)
      
        mapView.removeOverlays(mapView.overlays)
               }
        
        
    
// function to get directions
    func mapThis(destinationCord : CLLocationCoordinate2D) {
      
        let souceCordinate = (locationManager.location?.coordinate)!
        
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        print(destItem,"destiantion placemark")
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    print("Something is wrong :(")
                }
                return
            }
            
          let route = response.routes[0]
            self.mapView.addOverlay(route.polyline,level: .aboveRoads)
          self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
        self.mapView.delegate = self
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
          render.strokeColor = .yellow
          return render
      }
    
    
    
    
    
    
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
       {

         print(locations)
       }
    
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
   

    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        }

}

