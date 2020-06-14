//
//  favplaces.swift
//  findway_ram_c0779370
//
//  Created by rschakar on 6/13/20.
//  Copyright © 2020 rs_chakar. All rights reserved.
//


import Foundation
import MapKit

class favplaces: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func getPlaces() -> [favplaces] {
        guard let path = Bundle.main.path(forResource: "Places", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
        
        var places = [favplaces]()
        
        for item in array {
            let dictionary = item as? [String : Any]
            let title = dictionary?["title"] as? String
            let subtitle = dictionary?["description"] as? String
            let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = dictionary?["longitude"] as? Double ?? 0
            
            let place = favplaces(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
            places.append(place)
        }
        
        return places as [favplaces]
    }
}
