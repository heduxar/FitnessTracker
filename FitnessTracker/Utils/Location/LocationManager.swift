//
//  LocationManager.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 03.07.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    // MARK: - Private propeties
    private let locationManager = CLLocationManager()
    
    // MARK: - Public properties
    static let instance = LocationManager()
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    // MARK: - Object lifecycle
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    // MARK: - Private methods
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    private func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Public methods
    func startUpdatingLocation() {
        requestAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorizated")
        case .denied, .restricted, .notDetermined:
            print("Denied authorization")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
