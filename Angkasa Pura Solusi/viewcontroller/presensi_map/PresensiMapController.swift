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
    var firstTimeLoad = false
    var preparePresence: PreparePresence!
    var circles = [Circle]()
    var seconds = 0
    var minutes = 0
    var hours = 0
    var pickedCheckpointId = ""
    var currentLocation: CLLocation!
    var presenceType: String!
    
    @IBOutlet weak var viewPressence: UIView!
    @IBOutlet weak var viewJamMasukPulang: UIView!
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var labelClock: UIButton!
    @IBOutlet weak var viewHurryUp: UIView!
    @IBOutlet weak var labelJamMasuk: UILabel!
    @IBOutlet weak var labelJamKeluar: UILabel!
    @IBOutlet weak var buttonPresence: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initView()
        
        initLocationManager()
    }
    
    private func initView() {
        viewPressence.layer.cornerRadius = 6
        viewPressence.layer.shadowColor = UIColor.lightGray.cgColor
        viewPressence.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewPressence.layer.shadowRadius = 2
        
        viewHurryUp.layer.cornerRadius = 6
        viewHurryUp.layer.shadowColor = UIColor.lightGray.cgColor
        viewHurryUp.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewHurryUp.layer.shadowRadius = 2
        
        buttonPresence.layer.cornerRadius = buttonPresence.frame.height / 2
        
        viewJamMasukPulang.layer.cornerRadius = viewJamMasukPulang.frame.height / 2
        viewJamMasukPulang.layer.borderWidth = 2
        viewJamMasukPulang.layer.borderColor = UIColor.init(rgb: 0x42a5f5).cgColor
        
        labelJamMasuk.text = String((preparePresence.shift_start?.prefix(5))!)
        labelJamKeluar.text = String((preparePresence.shift_end?.prefix(5))!)
        
        let timeArray = preparePresence.time?.components(separatedBy: ":")
        
        seconds = Int(timeArray![2])!
        minutes = Int(timeArray![1])!
        hours = Int(timeArray![0])!
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            
            self.seconds += 1
            
            if self.seconds == 60 {
                self.minutes += 1
                self.seconds = 0
            }
            
            if self.minutes == 60 {
                self.hours += 1
                self.minutes = 0
            }
            
            UIView.performWithoutAnimation {
                self.labelClock.setTitle("\(self.preparePresence.day ?? ""), \(self.preparePresence.date ?? "") | \(String(self.hours).count == 1 ? "0\(self.hours)" : "\(self.hours)"):\(String(self.minutes).count == 1 ? "0\(self.minutes)" : "\(self.minutes)"):\(String(self.seconds).count == 1 ? "0\(self.seconds)" : "\(self.seconds)")", for: .normal)
                self.labelClock.layoutIfNeeded()
            }
        }
    }
    
    private func initMapView(_ location: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16.0)
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
    
    func addRadiusCircle(circle: Circle, isInside: Bool, isUpdate: Bool){
        
        if isInside {
            self.pickedCheckpointId = circle.checkpoint_id!
            circleInsideRadius(circle: circle.circle!)
            self.viewJamMasukPulang.isHidden = true
            self.viewHurryUp.isHidden = true
            self.viewPressence.isHidden = false
        } else {
            circleOutsideRadius(circle: circle.circle!)
            self.viewJamMasukPulang.isHidden = false
            self.viewHurryUp.isHidden = false
            self.viewPressence.isHidden = true
        }
        
        if !isUpdate {
            circle.circle?.map = self.mapview
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
    
    private func drawCircle() {
        for checkpoint in preparePresence.checkpoints {
            let buildingLat = Double(checkpoint.checkpoint_latitude!)
            let buildingLon = Double(checkpoint.checkpoint_longitude!)
            let circlePosition = CLLocationCoordinate2D(latitude: buildingLat!, longitude: buildingLon!)
            let stringRadius = checkpoint.checkpoint_radius?.components(separatedBy: ".")
            guard let nnRadius = stringRadius else {
                return
            }
            let radius = Double(nnRadius[0]) as! CLLocationDistance
            
            let circle = Circle(checkpoint_id: checkpoint.checkpoint_id, circle: GMSCircle(position: circlePosition, radius: radius))
            self.circles.append(circle)
            
            self.addRadiusCircle(circle: circle, isInside: false, isUpdate: false)
        }
    }
    
    private func checkDistance(_ currentLocation: CLLocation) {
        for circle in circles {
            
            let buildingLat = circle.circle?.position.latitude
            let buildingLon = circle.circle?.position.longitude
            let radius = circle.circle?.radius
            
            let distance = currentLocation.distance(from: CLLocation(latitude: buildingLat!, longitude: buildingLon!))
            
            if distance <= radius! {
                self.addRadiusCircle(circle: circle, isInside: true, isUpdate: true)
            } else {
                self.addRadiusCircle(circle: circle, isInside: false, isUpdate: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            
            currentLocation = CLLocation(latitude: location.coordinate.latitude as CLLocationDegrees, longitude: location.coordinate.longitude as CLLocationDegrees)
            self.updateLocationCoordinates(coordinates: location.coordinate)
            mapview.animate(to: GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16.0))
            
            if !firstTimeLoad {
                firstTimeLoad = true
                initMapView(currentLocation)
                drawCircle()
            }
            
            self.checkDistance(currentLocation)
            
            //let distance = currentLocation.distance(from: buildingLocation!)
            
            //addRadiusCircle(distance: distance)
            
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
    
    private func addPresence() {
        SVProgressHUD.show()
        
        buttonPresence.isEnabled = false
        
        presenceNetworking.addPresence(request: (checkpoint_id: pickedCheckpointId, presence_type: presenceType, latitude: String(currentLocation.coordinate.latitude), longitude: String(currentLocation.coordinate.longitude))) { (error) in
            
            SVProgressHUD.dismiss()
            self.buttonPresence.isEnabled = true
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Error Presence", error, "Retry", "Cancel", completionHandler: {
                    self.addPresence()
                })
                return
            }
            
            // TODO push to presence list controller
            
        }
    }
}

//click event
extension PresensiMapController {
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPresenceClick(_ sender: Any) {
        addPresence()
    }
}
