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

    @IBOutlet weak var infoBtn: UIButton!
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    var annotation = MKPointAnnotation()
    let destinationRequest = MKDirections.Request()
    
    @IBOutlet weak var walkingbtn: UIButton!
    @IBOutlet weak var zoomout: UIButton!
    @IBOutlet weak var zoomin: UIButton!
    @IBOutlet weak var doubleTap: UITapGestureRecognizer!
    @IBOutlet weak var findway: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var transportBtn: UIButton!
    
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
       
    
      
    }
    override func viewDidAppear(_ animated: Bool) {
           determineCurrentLocation()
           alertWelcome()
    
      }
  
    //Alert Welcome fn
    func alertWelcome(){
        let alert = UIAlertController(title: "Welcome", message: "1.Press Home Button to get your Location  & There is info button on top left of the screen for futher guides", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler:nil ))
               // show the alert
                      self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func infoAction(_ sender: UIButton) {
          alertUserlocation()
    }
    //zoom Out Button
    @IBAction func zoomoutAction(_ sender: UIButton) {
   
     zoomOutfunc()
    }
    
//Zoom In Button
    @IBAction func zoominAction(_ sender: UIButton) {
       zoomInfunc()
        
    }
    
//Double Tap Action
    @IBAction func doubleTapAction(_ sender: UITapGestureRecognizer) {
          print("doublepress tap")

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
    
//Walking Button action
    
      @IBAction func walkingActionbtn(_ sender: UIButton) {
           mapThis(destinationCord: annotation.coordinate)
          mapView.removeOverlays(mapView.overlays)
         medium(source: sender)
                 print("walking on")
                
      }
// Find way Button action
    @IBAction func findwayaction(_ sender: UIButton) {
          medium(source: sender)
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
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.requestsAlternateRoutes = false
      
        
        
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
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

      let polylineRenderer = MKPolylineRenderer(overlay: overlay)
      if (overlay is MKPolyline) {
        if mapView.overlays.count == 1 {
          polylineRenderer.strokeColor =
            UIColor.blue.withAlphaComponent(0.75)
        } else if mapView.overlays.count == 2 {
          polylineRenderer.strokeColor =
            UIColor.orange.withAlphaComponent(0.75)
        } else if mapView.overlays.count == 3 {
          polylineRenderer.strokeColor =
            UIColor.red.withAlphaComponent(0.75)
        }
        polylineRenderer.lineWidth = 5
      }
      return polylineRenderer

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
    
    
   
//function to get current Loacation
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        }
    
    
    
    
    
//User location fn
    func yourLocation(_Location: CLLocation){
        let location = locationManager.location!
                     let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan( latitudeDelta: 0.01, longitudeDelta: 0.01))
                     region.center = mapView.userLocation.coordinate
                     mapView.setRegion(region, animated: true)
      
    }
    
    
    //Alert userlocation fn
      func alertUserlocation(){
          let alert = UIAlertController(title: "Select Destiantion", message: "1.Please use magnifier Buttons for Zoom in and Zoom out  2.Double tap to set a destination location  3. Select a medium of transport from the right bottom buttons  4.Double tap walking Button for walking Route", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler:nil ))
                 // show the alert
                        self.present(alert, animated: true, completion: nil)
      }
    
//Zoom Out Function
     func zoomOutfunc(){
      
//
//        let maxRegion=MKCoordinateRegion(center:mapView.region.center ,span:  MKCoordinateSpan(latitudeDelta: +214.98590353, longitudeDelta: +162.98586887));
      
         let newRegion=MKCoordinateRegion(center: mapView.region.center,span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta/0.5, longitudeDelta: mapView.region.span.longitudeDelta/0.5));
            mapView.setRegion(newRegion,animated: true)
         
     }
     
     
     
     //Zoom in Function
     func zoomInfunc(){
         let newRegion=MKCoordinateRegion(center: mapView.region.center,span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta*0.5, longitudeDelta: mapView.region.span.longitudeDelta*0.5));
               mapView.setRegion(newRegion, animated: true)
         
     }
    
    
    
//Medium function
    func medium(source:UIButton){
        if(source.tag==1){
            print ("Walking")
            destinationRequest.transportType = .walking
            
        }
        else if(source.tag==2){
            print("Automobile")
            destinationRequest.transportType = .automobile
        }
    }
    
  

}

