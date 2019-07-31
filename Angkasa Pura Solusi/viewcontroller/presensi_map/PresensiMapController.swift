//
//  PresensiMapController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD

class PresensiMapController: BaseViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var marker: GMSMarker?
    var circle: GMSCircle?
    var buildingLocation: CLLocation?

    @IBOutlet weak var viewPressence: UIView!
    @IBOutlet weak var viewJamMasukPulang: UIView!
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var labelClock: UIButton!
    @IBOutlet weak var viewHurryUp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        buildingLocation = CLLocation(latitude: -7.8061 as CLLocationDegrees, longitude: 110.3770 as CLLocationDegrees)
        
        initMapView()
        
        initLocationManager()
    }
    
    private func initMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: (buildingLocation?.coordinate.latitude)!, longitude: (buildingLocation?.coordinate.longitude)!, zoom: 16.0)
        mapview.animate(to: camera)
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        //this line of code below to set the range of the accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //this line of code below to prompt the user for location permission
        locationManager.requestWhenInUseAuthorization()
        //this line of code below to start updating the current location
        locationManager.startUpdatingLocation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func circleInsideRadius(circle: GMSCircle) {
        circle.fillColor = UIColor.init(rgb: 0x9ccc65).withAlphaComponent(0.5)
        circle.strokeColor = UIColor.init(rgb: 0x7eb73d).withAlphaComponent(0.5)
        circle.strokeWidth = 3
    }
    
    private func circleOutsideRadius(circle: GMSCircle) {
        circle.fillColor = UIColor.init(rgb: 0xef5350).withAlphaComponent(0.5)
        circle.strokeColor = UIColor.init(rgb: 0xef5350).withAlphaComponent(0.5)
        circle.strokeWidth = 1
    }
    
    func addRadiusCircle(distance: CLLocationDistance){
        let circleCenter = CLLocationCoordinate2D(latitude: -7.8061, longitude: 110.3770)
        
        if let circle = circle {
            
            if distance < 150 {
                circleInsideRadius(circle: circle)
            } else {
                circleOutsideRadius(circle: circle)
            }
            
        } else {
            circle = GMSCircle(position: circleCenter, radius: 100)
            
            if distance < 150 {
                circleInsideRadius(circle: circle!)
            } else {
                circleOutsideRadius(circle: circle!)
            }
            
            circle!.map = self.mapview
        }
        
//        mapview.delegate = self
//        let circle = MKCircle(center: location.coordinate, radius: 200 as CLLocationDistance)
//        mapview.addOverlay(circle)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if !(annotation is MKPointAnnotation) {
//            return nil
//        }
//
//        let annotationIdentifier = "AnnotationIdentifier"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            annotationView!.canShowCallout = true
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//
//        let pinImage = UIImage(named: "group425")
//        annotationView!.image = pinImage
//
//        return annotationView
//    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is MKCircle {
//            let circle = MKCircleRenderer(overlay: overlay)
//            //circle.strokeColor = UIColor.init(rgb: 0xef5350)
//            circle.fillColor = UIColor.init(rgb: 0xef5350).withAlphaComponent(0.5)
//            //circle.lineWidth = 1
//            return circle
//        } else {
//            return MKPolylineRenderer()
//        }
//    }
    
//    private func setMarker(location: CLLocationCoordinate2D) {
//        let markerImage =
//        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//        marker.icon = markerImage
//        marker.title = "My Location"
//        marker.map = mapview
//    }
    
    func updateLocationCoordinates(coordinates:CLLocationCoordinate2D) {
        if marker == nil{
            marker = GMSMarker()
            marker!.position = coordinates
            marker!.icon = UIImage(named: "group425")
            marker!.map = mapview
            marker!.appearAnimation = .pop
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            marker!.position =  coordinates
            CATransaction.commit()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            
            let currentLocation = CLLocation(latitude: location.coordinate.latitude as CLLocationDegrees, longitude: location.coordinate.longitude as CLLocationDegrees)
            self.updateLocationCoordinates(coordinates: location.coordinate)
            mapview.animate(to: GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16.0))
            
            let distance = currentLocation.distance(from: buildingLocation!)
            
            addRadiusCircle(distance: distance)
            
            //mapview.animate(toLocation: center)
            //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            //self.mapview.setRegion(region, animated: true)
            
            //Drop a pin at user's Current Location
            //let myAnnotation = MKPointAnnotation()
            //myAnnotation.coordinate = center
            //myAnnotation.title = "Current location"
            //mapview.addAnnotation(myAnnotation)
        }
    }
}

//click event
extension PresensiMapController {
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
