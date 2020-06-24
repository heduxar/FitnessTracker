//
//  MainViewController.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

protocol MainDisplayLogic: class {
    func displaySomething(viewModel: Main.Something.ViewModel)
}

final class MainViewController: UIViewController, CustomableView {
    typealias RootView = MainView
    
    // MARK: - Private Properties
    private let interactor: MainBusinessLogic
    private var state: Main.ViewControllerState
    private var route: RealmTrackModel?
    private let locationManager = CLLocationManager()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
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
        loadRealmModel()
    }
    
    // MARK: - Private Methods
    private func requestLocationAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func loadRealmModel() {
        guard let route = try? RealmProvider.get(RealmTrackModel.self).first else {
            self.route = RealmTrackModel()
            self.route?.id = 1
            try? RealmProvider.save(items: [self.route!])
            return
        }
        self.route = route
    }
    
    private func startBackgroundTrack() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }
    
    private func finishBackgroundTrack() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    private func zoomToLocation() {
        guard let location = locationManager.location?.coordinate else { return }
        view().updateLocation(location: location)
    }
    
    private func getPreviosRoute(completion: ([CLLocationCoordinate2D]?) -> Void) {
        guard let previosRoute = try? RealmProvider.get(RealmTrackModel.self).first else {
            completion(nil)
            return
        }
        var route: [CLLocationCoordinate2D] = []
        previosRoute.locationPoints.forEach { point in
            route.append(point.coordinate)
        }
        completion(route)
    }
    
    private func addRealmPoint(location: CLLocationCoordinate2D) {
        let realmCoordinates = RealmCoordinatesModel()
        realmCoordinates.latitude = location.latitude
        realmCoordinates.longitude = location.longitude
        guard let realm = try? Realm(configuration: .defaultConfiguration) else { return }
        try! realm.write {
            route?.locationPoints.append(realmCoordinates)
        }
        
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
        view().zoomToLocationSwitcher(location: location.coordinate)
    }
    
    func didTapStartStopButton() {
        switch view().status {
        case .start:
            startBackgroundTrack()
            view().setStatus(status: .progress)
            view().startRouteButton.setBackgroundImage(UIImage(systemName: "stop.fill"),
                                                       for: .normal)
            if let route = route {
                route.locationPoints.forEach { point in
                    try? RealmProvider.delete(item: point)
                }
                try? RealmProvider.delete(item: route)
            
                loadRealmModel()
            }
            if let location = locationManager.location?.coordinate {
                view().clearMap {
                    view().updateLocation(location: location)
                    view().setStartMarker(location: location)
                    view().addRoutePoint(point: location)
                }
            }
        case .progress:
            view().setStatus(status: .start)
            view().startRouteButton.setBackgroundImage(UIImage(systemName: "play.fill"),
                                                       for: .normal)
            if let route = route,
                let location = locationManager.location?.coordinate {
                try? RealmProvider.save(items: [route])
                view().addRoutePoint(point: location)
                view().setFinishMarker(location: location)
                
            }
            finishBackgroundTrack()
        case .finish:
            break
        }
    }
    
    func didTapPreviosRoute() {
        if view().status == .progress {
            //TODO: Alert stop track
            didTapStartStopButton()
        }
        guard let route = try? RealmProvider.get(RealmTrackModel.self).first else { return }
        let previosRoute: [CLLocationCoordinate2D] = route.locationPoints.compactMap {$0.coordinate}
        view().setRoute(route: previosRoute)
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
        switch view().status {
        case .progress:
            view().addRoutePoint(point: firstLocation.coordinate)
            addRealmPoint(location: firstLocation.coordinate)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
