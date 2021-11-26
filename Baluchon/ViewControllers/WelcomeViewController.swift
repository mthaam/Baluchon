//
//  WelcomeViewController.swift
//  Baluchon
//
//  Created by SEBASTIEN BRUNET on 26/11/2021.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController {

    var locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authorize(_ sender: Any) {
        Core.shared.isNotNewUser()
        setupLocation()
    }

}

// MARK: - CLLOCATION MANAGER DELEGATE

extension WelcomeViewController: CLLocationManagerDelegate {

    /// This function updates location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    /// This function is called in case there is an error while
    /// retrieving location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    /// This function stops updating location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    }

    /// This function dismisses storyboard after authorization change
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        dismiss(animated: true, completion: nil)
    }

}

class Core {

    static let shared = Core()

    /// This functions returns a boolean,
    /// which states user is new.
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }

    /// This function sets "isNewUser" to true.
    func isNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }

}
