//
//  AddLocMapViewController.swift
//  OnTheMap
//
//  Created by Work  on 12/27/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var studentLocation: StudentInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        mapView.delegate = self
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Finish(_ sender: Any) {
  
//        let loc = PostStudentLocation(studentLocation!.latitude)
        let location = PostStudentLocation(uniqueKey: "",
                                           firstName: (studentLocation?.firstName)!,
                                           lastName: (studentLocation?.lastName)!,
                                           mapString: (studentLocation?.mapString)!,
                                           mediaURL: (studentLocation?.mediaURL)!,
                                           latitude: (studentLocation?.latitude)!,
                                           longitude: (studentLocation?.longitude)! )
        
        
//        let loc = postStudent
        API.shared.postStudent(location) { (success, error) in
            if !success || error != nil {
                let msg = error?.localizedDescription
                self.ShowAlert(title: "Error!", msg: msg!)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    
    }
    
    
    func ShowAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setupMap(){
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        //        var locations = locationData?.studentsLocationsData
        var locations = studentLocation
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
        let lat = CLLocationDegrees((studentLocation?.latitude)!)
        let long = CLLocationDegrees((studentLocation?.longitude)!)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = studentLocation?.mapString
           
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        
    
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
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
}
