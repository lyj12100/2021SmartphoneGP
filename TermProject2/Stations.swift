//
//  Stations.swift
//  TermProject2
//
//  Created by KpuGame on 2021/05/20.
//

import Foundation
import MapKit
import Contacts

class Stations: NSObject, MKAnnotation{
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, coordinate:CLLocationCoordinate2D){
        
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
   // var subtitle: String?{
   //     return serviceAreaName
   // }
    
    func mapItem() -> MKMapItem{
        //let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
}
