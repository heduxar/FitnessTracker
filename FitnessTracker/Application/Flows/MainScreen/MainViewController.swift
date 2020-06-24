//
//  MainViewController.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import CoreLocation

protocol MainDisplayLogic: class {
    func displaySomething(viewModel: Main.Something.ViewModel)
}

final class MainViewController: UIViewController, CustomableView {
    typealias RootView = MainView
    
    // MARK: - Private Properties
    private let interactor: MainBusinessLogic
    private var state: Main.ViewControllerState
    private let locationManager = CLLocationManager()
    
    // MARK: - Object Lifecycle
    init(interactor: MainBusinessLogic, initialState: Main.ViewControllerState = .initial) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        let view = MainView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAuthorization()
    }
    
    // MARK: - Private Methods
    private func requestLocationAuthorization() {
        locationManager.distanceFilter = 25
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLocation() {
        guard let location = locationManager.location?.coordinate else { return }
        view().updateLocation(location: location)
    }
}

// MARK: - Display Logic
extension MainViewController: MainDisplayLogic {
    func displaySomething(viewModel: Main.Something.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func display(newState: Main.ViewControllerState) {
        state = newState
        switch state {
        case .initial:
            print("initial state")
        case let .failure(error):
            print("error \(error)")
        case let .result(items):
            print("result: \(items)")
        case .emptyResult:
            print("empty result")
        }
    }
}

// MARK: - View Delegate
extension MainViewController: MainViewDelegate {
    func didTapLocationButton() {
        guard let location = locationManager.location else { return }
        view().currentLocation(location: location.coordinate)
        
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            zoomToLocation()
        case .denied, .restricted, .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        view().updateLocation(location: firstLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
