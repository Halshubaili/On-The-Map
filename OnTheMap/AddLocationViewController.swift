//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Work  on 12/27/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FindLocationBtn(_ sender: Any) {
        
        if  (link.text?.isEmpty)! || (location.text?.isEmpty)! {
           self.ShowAlert(title: "Some fields are missing", msg: "Please fill all fields any try again!")
            return }
        //spinner
        //WRONG!!!!!!
        let student = StudentInfo(objectId: "",
                                  uniqueKey: "",
                                  firstName: "",
                                  lastName: "",
                                  mapString: self.location.text!,
                                  latitude: 0,
                                  longitude: 0,
                                  mediaURL: self.link.text!,
                                  updatedAt: "",
                                  createdAt: "")
    
        self.passGeocodeCoordinates(student)
        
        
    }//End FindLoc
   
    func passGeocodeCoordinates(_ student: StudentInfo){
        
        startLoading(onView: self.view)
        let mapString = student.mapString
        CLGeocoder().geocodeAddressString(mapString) { (placemarks, error) in
       self.stopLoading()
            
            guard let locations = placemarks?.first?.location else {
                self.ShowAlert(title: "Sorry", msg: "No locations found with specified coordinates")
                return
            }
            var studentLocation = student
            studentLocation.latitude = locations.coordinate.latitude
            studentLocation.longitude = locations.coordinate.longitude
            
            self.performSegue(withIdentifier: "addLocMap", sender: studentLocation)
        
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocMap", let viewController = segue.destination as? AddLocMapViewController {
            viewController.studentLocation = (sender as! StudentInfo)
        }
    }
    
    func ShowAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
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
}
