//
//  PublicFunction.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import Kingfisher

class PublicFunction {
    
    //static let instance = PublicFunction()
    
    /*
     bottom_right = .layerMaxXMaxYCorner
     bottom_left = .layerMinXMaxYCorner
     top_right = .layerMaxXMinYCorner
     top_left = .layerMinXMinYCorner
     */
    
    let imageCache = NSCache<NSString, UIImage>()
    let imageCacheKey: NSString = "CachedMapSnapshot"
    
    open func getStraightDistance(latitude: Double, longitude: Double) -> Double{
        let location = CLLocation()
        return location.distance(from: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    func present(_ origin: UIViewController, _ destination: UIViewController, _ navigationController: UINavigationController) {
        origin.present(destination, animated: true)
    }
    
    func push(_ viewController: UIViewController, _ navigationController: UINavigationController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    open func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    return
                }
                
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    print(addressString)
                }
        })
    }
    
    open func timerConnection() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            print("timer is running")
        }
    }
    
    ///////////////////////////////////////////////////////////////////////
    ///  This function converts decimal degrees to radians              ///
    ///////////////////////////////////////////////////////////////////////
    func deg2rad(deg:Double) -> Double {
        return deg * .pi / 180
    }
    
    ///////////////////////////////////////////////////////////////////////
    ///  This function converts radians to decimal degrees              ///
    ///////////////////////////////////////////////////////////////////////
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / .pi
    }
    
    open func statusBarHeight() -> CGFloat{
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    func cacheImage(image: UIImage) {
        imageCache.setObject(image, forKey: imageCacheKey)
    }
    
    func cachedImage() -> UIImage? {
        return imageCache.object(forKey: imageCacheKey)
    }
    
    open func errorMessage(_ response: String) -> String {
        var stringResponse = response
        stringResponse = stringResponse.replacingOccurrences(of: "SUCCESS: ", with: "")
        stringResponse = stringResponse.replacingOccurrences(of: "{", with: "")
        stringResponse = stringResponse.replacingOccurrences(of: "}", with: "")
        stringResponse = stringResponse.replacingOccurrences(of: "code = 401;", with: "")
        stringResponse = stringResponse.replacingOccurrences(of: "message = ", with: "")
        stringResponse = stringResponse.replacingOccurrences(of: ";", with: "")
        return stringResponse.trim()
    }
    
    open func setShadow(_ view: UIView, _ cornerRadius: CGFloat, _ shadowColor: CGColor, _ width: CGFloat, _ height: CGFloat, _ shadowRadius: CGFloat, _ opacity: Float){
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowColor = shadowColor
        view.layer.shadowOffset = CGSize(width: width, height: height)
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowOpacity = opacity
    }
    
    open func loadStaticMap(_ latitude: Double, _ longitude: Double, _ metters: Double, _ image: UIImageView, _ markerFileName: String) {
        if let cachedImage = self.cachedImage() {
            image.image = cachedImage
            return
        }
        
        let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let distanceInMeters: Double = metters
        
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coords, latitudinalMeters: distanceInMeters, longitudinalMeters: distanceInMeters)
        options.size = image.frame.size
        
        let bgQueue = DispatchQueue.global(qos: .background)
        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start(with: bgQueue, completionHandler: { [weak self] (snapshot, error) in
            guard error == nil else {
                return
            }
            
            if let snapShotImage = snapshot?.image, let coordinatePoint = snapshot?.point(for: coords), let pinImage = UIImage(named: markerFileName) {
                UIGraphicsBeginImageContextWithOptions(snapShotImage.size, true, snapShotImage.scale)
                snapShotImage.draw(at: CGPoint.zero)
                
                let fixedPinPoint = CGPoint(x: coordinatePoint.x - pinImage.size.width / 2, y: coordinatePoint.y - pinImage.size.height)
                pinImage.draw(at: fixedPinPoint)
                let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                if let unwrappedImage = mapImage {
                    self?.cacheImage(image: unwrappedImage)
                }
                
                DispatchQueue.main.async {
                    image.image = mapImage
                }
                UIGraphicsEndImageContext()
            }
        })
    }
    
    open func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        
        if (unit == "Kilometer") {
            dist = dist * 1.609344
        }
        else if (unit == "Nautical Miles") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    open func getCurrentDate(pattern: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = pattern
        return formater.string(from: Date())
    }
    
    open func getCurrentMillisecond(pattern: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return Double((formatter.date(from: getCurrentDate(pattern: pattern))?.timeIntervalSince1970)! * 1000.0)
    }
    
    open func dateLongToString(dateInMillis: Double, pattern: String) -> String {
        let date = Date(timeIntervalSince1970: (dateInMillis / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        return dateFormatter.string(from: date)
    }
    
    open func dateStringToInt(stringDate: String, pattern: String) -> Double{
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return Double((formatter.date(from: stringDate)?.timeIntervalSince1970)! * 1000.0)
    }
    
    open func changeStatusBar(hexCode: Int, view: UIView, opacity: CGFloat){
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(rgb: hexCode).withAlphaComponent(opacity)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    open func changeTintColor(imageView: UIImageView, hexCode: Int, alpha: CGFloat) {
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(rgb: hexCode).withAlphaComponent(alpha)
    }
    
    open func stretchToSuperView(view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        var d = Dictionary<String,UIView>()
        d["view"] = view
        for axis in ["H","V"] {
            let format = "\(axis):|[view]|"
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: [:], views: d)
            view.superview?.addConstraints(constraints)
        }
    }
    
    open func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    open func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionTitle: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            completionHandler()
        }))
        viewController.present(alert, animated: true)
    }
    
    open func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionTitle: String, _ actionTitle2: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            completionHandler()
        }))
        alert.addAction(UIAlertAction(title: actionTitle2, style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    open func createQRFromString(_ str: String, size: CGSize) -> UIImage {
        let stringData = str.data(using: .utf8)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        
        let minimalQRimage = qrFilter.outputImage!
        // NOTE that a QR code is always square, so minimalQRimage..width === .height
        let minimalSideLength = minimalQRimage.extent.width
        
        let smallestOutputExtent = (size.width < size.height) ? size.width : size.height
        let scaleFactor = smallestOutputExtent / minimalSideLength
        let scaledImage = minimalQRimage.transformed(
            by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        return UIImage(ciImage: scaledImage,
                       scale: UIScreen.main.scale,
                       orientation: .up)
    }
    
    open func getDate(stringDate: String, pattern: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: stringDate) // replace Date String
    }
    
    open func prettyRupiah(_ money: String) -> String {
        var result = money
        
        switch money.count {
        case 1, 2, 3: //satuan, puluhan, ratusan
            result = money
        case 4: //ribuan
            let index = result.index(result.startIndex, offsetBy: 1)
            result.insert(".", at: index)
        case 5: //puluhan ribu
            let index = result.index(result.startIndex, offsetBy: 2)
            result.insert(".", at: index)
        case 6: //ratusan ribu
            let index = result.index(result.startIndex, offsetBy: 3)
            result.insert(".", at: index)
        case 7: //jutaan
            let index1 = result.index(result.startIndex, offsetBy: 1)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 5)
            result.insert(".", at: index2)
        case 8: //puluhan juta
            let index1 = result.index(result.startIndex, offsetBy: 2)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 6)
            result.insert(".", at: index2)
        case 9: //ratusan juta
            let index1 = result.index(result.startIndex, offsetBy: 3)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 7)
            result.insert(".", at: index2)
        case 10: //milyar
            let index1 = result.index(result.startIndex, offsetBy: 1)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 5)
            result.insert(".", at: index2)
            let index3 = result.index(result.startIndex, offsetBy: 9)
            result.insert(".", at: index3)
        default:
            break
        }
        
        return result
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension String{
    func trim() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
}

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}

extension UIButton {
    func getURL2(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data),
                httpURLResponse.url == url
                else { return }
            DispatchQueue.main.async() {
                self.setImage(image, for: .normal)
                self.imageView?.contentMode = .scaleAspectFit
                //self.image = image
            }
            }.resume()
    }
    
    public func downloadedFrom2(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        getURL2(url: url, contentMode: mode)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIImageView {
    func loadUrl(_ url: String) {
        self.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "Artboard 10@0.75x-8"))
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}

extension UIView {
    
    public class func fromNib() -> Self {
        return fromNib(nibName: nil)
    }
    
    public class func fromNib(nibName: String?) -> Self {
        func fromNibHelper<T>(nibName: String?) -> T where T : UIView {
            let bundle = Bundle(for: T.self)
            let name = nibName ?? String(describing: T.self)
            return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
        }
        return fromNibHelper(nibName: nibName)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
