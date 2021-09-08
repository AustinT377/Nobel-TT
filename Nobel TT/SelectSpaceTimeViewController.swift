//
//  SelectSpaceTimeViewController.swift
//  Nobel TT
//
//  Created by Austin Turner on 10/22/20.
//

import UIKit
import MapKit
import CoreLocation

protocol updateSpaceTimeProtocol {
    func updateSpaceTime(coordinates: CLLocation, date: Date)
}

class SelectSpaceTimeViewController: UIViewController {
    
    var delegate: updateSpaceTimeProtocol?
    var location: CLLocation?
    var date: Date?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationNotEnabledButton: UIButton!
    @IBOutlet weak var userLocationButton: UIButton!
    
    @IBAction func datePickerChanged(_ sender: Any) {
        self.date = self.datePicker.date
    }
    
    @IBAction func currentLocationSelected(_ sender: Any) {
        let userLocation = LocationManager.shared.getCurrentLocation()
        
        let clLocation: CLLocationCoordinate2D = userLocation.coordinate
        
        mapView.setCenter(clLocation, animated: true)
    }
    
    @IBAction func cancelSelected(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enableLocationServices(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        let mapCoordinates = mapView!.centerCoordinate
        let tmpCenter = CLLocation(latitude: mapCoordinates.latitude, longitude: mapCoordinates.longitude)
        guard let tmpDate = self.date else {return}

        self.delegate?.updateSpaceTime(coordinates: tmpCenter, date: tmpDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = true
        
        let region = MKCoordinateRegion(center: self.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        mapView.setRegion(region, animated: false)
        self.datePicker.setDate(self.date ?? Date(), animated: false)
        
        let permission = LocationManager.shared.locationManager.authorizationStatus
        
        switch permission {
        case .denied, .restricted, .notDetermined:
            self.locationNotEnabledButton.isHidden = false
            self.userLocationButton.isHidden = true
        default:
            self.locationNotEnabledButton.isHidden = true
            self.userLocationButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.view.backgroundColor = UIColor.init(displayP3Red: 232/255, green: 232/255, blue: 232/255, alpha: 0.4)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
