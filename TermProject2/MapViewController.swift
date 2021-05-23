//
//  MapViewController.swift
//  TermProject2
//
//  Created by KpuGame on 2021/05/18.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, XMLParserDelegate {

    
    var url: String?
    var parser = XMLParser()
    var elements = NSMutableDictionary()
    var element = NSString()
    var posts = NSMutableArray()
    var unitName = NSMutableString()
    var xValue = NSMutableString()
    var yValue = NSMutableString()
    //-----------
    //var lat : Double
    //var lon : Double
    var stations : [Stations] = [] //= []
    
    let regionRadius: CLLocationDistance = 5000
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        loadInitialData()
        let initialLocation = CLLocation(latitude: (yValue as NSString).doubleValue, longitude: (xValue as NSString).doubleValue)
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        
        mapView.addAnnotations(stations)
        
    }
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        mapView!.reloadInputViews()

    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] ) {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "list")
        {
            elements = NSMutableDictionary()
            elements = [:]
            unitName = NSMutableString()
            unitName = ""
            xValue = NSMutableString()
            xValue = ""
            yValue = NSMutableString()
            yValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "unitName"){
            unitName.append(string)
        }else if element.isEqual(to: "xValue"){
            xValue.append(string)
        }else if element.isEqual(to: "yValue"){
            yValue.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName as NSString).isEqual(to: "list"){
            if !unitName.isEqual(nil){
                elements.setObject(unitName, forKey: "unitName" as NSCopying)
            }
            if !xValue.isEqual(nil){
                elements.setObject(xValue, forKey: "xValue" as NSCopying)
            }
            if !yValue.isEqual(nil){
                elements.setObject(yValue, forKey: "yValue" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
            
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func loadInitialData(){
        for post in posts{
            let unitName = (post as AnyObject).value(forKey: "unitName") as! NSString as String
            let xValue = (post as AnyObject).value(forKey: "xValue") as! NSString as String
            let yValue = (post as AnyObject).value(forKey: "yValue") as! NSString as String
           
            let lat = (yValue as NSString).doubleValue
            let lon = (xValue as NSString).doubleValue
            let station = Stations(title: unitName, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            stations.append(station)
            print(stations)
        }
    }
    
 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let location = view.annotation as! Stations
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? Stations else {return nil}
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        }else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

}

