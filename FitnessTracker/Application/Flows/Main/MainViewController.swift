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
import RxSwift
import RxCocoa

protocol MainDisplayLogic: class {
    func displaySomething(viewModel: Main.Something.ViewModel)
}

final class MainViewController: UIViewController, CustomableView {
    typealias RootView = MainView
    
    // MARK: - Private Properties
    private let interactor: MainBusinessLogic
    private var state: Main.ViewControllerState
    private var route: RealmTrackModel?
    private let locationManager = LocationManager.instance
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private let bag = DisposeBag()
    
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
        UserDefaults.standard.isSecuredScreen = false
        loadRealmModel()
        configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Private Methods
    private func loadRealmModel() {
        guard let route = try? RealmProvider.get(RealmTrackModel.self).last else {
            self.route = RealmTrackModel()
            self.route?.id = 1
            self.route?.startTime = Date()
            try? RealmProvider.save(items: [self.route!])
            return
        }
        let newRoute = RealmTrackModel()
        newRoute.id = route.id + 1
        newRoute.startTime = Date()
        self.route = newRoute
        try? RealmProvider.save(items: [self.route!])
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
    
    private func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let self = self,
                    let location = location
                    else { return }
                self.view().updateLocation(location: location.coordinate)
                switch self.view().status {
                case .progress:
                    self.addRealmPoint(location: location.coordinate)
                    self.view().addRoutePoint(point: location.coordinate)
                default:
                    break
                }
        }
        .disposed(by: bag)
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLocation() {
        guard let location = locationManager.location.value?.coordinate else { return }
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
        realmCoordinates.date = Date()
        guard let realm = try? Realm(configuration: .defaultConfiguration) else { return }
        try! realm.write {
            route?.locationPoints.append(realmCoordinates)
        }
    }
    
    private func showStopTrackAlert() {
        let alert: UIAlertController = {
            let alertController = UIAlertController(title: "Stop track?",
                                                    message: "Are you sure want to stop track current route?",
                                                    preferredStyle: .actionSheet)
            let stopButton = UIAlertAction(title: "Stop",
                                      style: .destructive) { [weak self] _ in
                                        guard let currenID = self?.route?.id,
                                            let route = try? RealmProvider.get(RealmTrackModel.self)
                                            .first(where: { $0.id == (currenID - 1)}),
                                            !route.locationPoints.isEmpty else { return }
                                        self?.didTapStartStopButton()
                                        self?.view().setRoute(route: route)
            }
            let continuousButton = UIAlertAction(title: "Continue",
                                                 style: .default) { _ in alertController.dismiss(animated: true,
                                                                                                    completion: nil)
            }
            
            alertController.addAction(continuousButton)
            alertController.addAction(stopButton)
            
            return alertController
        }()
        
        self.present(alert, animated: true)
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
        zoomToLocation()
    }
    
    func didTapStartStopButton() {
        switch view().status {
        case .start:
            startBackgroundTrack()
            view().setStatus(status: .progress)
            
//            if let route = route {
//                route.locationPoints.forEach { point in
//                    try? RealmProvider.delete(item: point)
//                }
//                try? RealmProvider.delete(item: route)
//
//                loadRealmModel()
//            }
            UserDefaults.standard.isTrackRoute = true
            if let location = locationManager.location.value?.coordinate {
                view().clearMap {
                    view().updateLocation(location: location)
                    view().setStartMarker(location: location)
                    view().addRoutePoint(point: location)
                }
            }
            
        case .progress:
            view().setStatus(status: .start)
            UserDefaults.standard.isTrackRoute = false
            if let route = route,
                let location = locationManager.location.value?.coordinate {
                guard let realm = try? Realm(configuration: .defaultConfiguration) else { return }
                try! realm.write {
                    route.endTime = Date()
                }
                try? RealmProvider.save(items: [route])
                view().addRoutePoint(point: location)
                view().setFinishMarker(location: location)
            }
            
            finishBackgroundTrack()
            
        case .finish:
            break
        }
        
        view().updateLocation(location: locationManager.location.value?.coordinate)
    }
    
    func didTapPreviosRoute() {
        if view().status == .progress {
            showStopTrackAlert()
        } else {
            guard let currentID = self.route?.id,
                let route = try? RealmProvider.get(RealmTrackModel.self)
                .first(where: { $0.id == currentID - 1 }),
                !route.locationPoints.isEmpty else { return }
            view().setRoute(route: route)
        }
        
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

extension MainViewController {
    
}
