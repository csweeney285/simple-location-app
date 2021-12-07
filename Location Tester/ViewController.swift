//
//  ViewController.swift
//  Location Tester
//
//  Created by Conor Sweeney on 12/7/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    let locationManager = CLLocationManager()
    
    @IBAction func getLocation(_ sender: Any) {
        self.locationManager.requestLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addressFromCLLocation(location: CLLocation) {
        let ceo: CLGeocoder = CLGeocoder()
        ceo.reverseGeocodeLocation(location, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("Reverse Geodcode Failed: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                if let country = pm.country {
                    print("Country: \(country)")
                }
                if let locality = pm.locality {
                    print("Locality: \(locality)")
                    self.addressLabel.text = locality
                }
                if let sublocatilty = pm.subLocality {
                    print("Sublocatilty: \(sublocatilty)")
                }
                
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
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        latLabel.text = "\(String(describing:location.coordinate.latitude))";
        longLabel.text = "\(String(describing:location.coordinate.longitude))";
        self.addressFromCLLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Failed: \(error.localizedDescription)")
        addressLabel.text = "Failed"
        latLabel.text = "Failed";
        longLabel.text = "Failed";
    }
}

