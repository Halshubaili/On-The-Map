//
//  TableVC.swift
//  OnTheMap
//
//  Created by Work  on 12/15/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var link: UILabel!
    
}

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let show:String = "show"
    let hide: String = "hide"
    @IBOutlet weak var tableview: UITableView!
    var list: [StudentInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsLocations()
        tableview.dataSource =  self
        tableview.delegate = self
        tableview.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "customCell") as! TableViewCell
        let rowItem = self.list?[indexPath.row]
        
    
        cell.city.text = (rowItem?.firstName ?? "") + " " + (rowItem?.lastName ?? "")
//        cell.city.text = rowItem?.mapString
        cell.link.text = rowItem?.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let rowItem = self.list?[indexPath.row]
        let urls = rowItem?.mediaURL
        if let url = NSURL(string: urls ?? ""){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
//    @IBAction func AddLocation(_ sender: Any) {
//    }
    
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
                self.list = data
            }
        }
        
    }
    
    @IBAction func Logout(_ sender: Any) {
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
