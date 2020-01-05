//
//  MapVC.swift
//  OnTheMap
//
//  Created by Work  on 12/15/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
        
    @IBOutlet weak var mapView: MKMapView!

    var list: [StudentInfo] = [] {
    didSet{
        setupMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsLocations()
        mapView.reloadInputViews()
        mapView.delegate = self
        
    }
    
    func setupMap(){
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
//        var locations = locationData?.studentsLocationsData
        var locations = list
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
             let link = view.annotation?.subtitle
            if let url = NSURL(string: link as! String){
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    
    func getStudentsLocations(){
        
        API.shared.getAllStudents { (data, error) in
            guard let data = data else {
               self.showAlert(title: "Sorry..", msg: "Check your connection")
                return
            }
            if (data.count) <= 0 {
                self.showAlert(title: "Sorry..", msg: "Nothing found!")
                return
            }
            DispatchQueue.main.async {
                self.list = data
            }
            
        }
        
        
    }
    
    
    @IBAction func Refresh(_ sender: Any) {
        startLoading(onView: self.view)
        API.shared.getAllStudents { (data, error) in
            if (data?.count)! <= 0 {
                let alert = UIAlertController(title: "Sorry..", message: "Nothing found!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            DispatchQueue.main.async {
                self.stopLoading()
                self.list = data!
            }
        }
    }
    
    
    @IBAction func LogoutBtn(_ sender: Any) {
        startLoading(onView: self.view)
         API.shared.logout(completion: {(success, error) in
            DispatchQueue.main.async {
               self.stopLoading()
                if (success) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                }
            }
        })
    }
    
    /* src:
     http://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
     */
    var vSpinner : UIView?
    func startLoading(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
}



