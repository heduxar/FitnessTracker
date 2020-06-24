//
//  MainView.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MainViewDelegate: class {
    func didTapLocationButton()
    func didTapStartStopButton()
    func didTapPreviosRoute()
}

enum TrackStatus {
    case start, progress, finish
}

extension MainView {
    struct ViewMetrics {
        let locationButtonSize = CGSize(width: 32.0,
                                        height: 32.0)
        let locationButtonInsets = UIEdgeInsets(top: 0.0,
                                                left: 0.0,
                                                bottom: 8.0,
                                                right: 8.0)
        let markersColor = UIColor.systemBlue
        let startPointColor = UIColor.systemGreen
        let finishPointColor = UIColor.systemRed
        let routePolylineColor = UIColor.systemBlue
        let routeStrokeWidth: CGFloat = 3
        
        
        let routeInsets = UIEdgeInsets(top: 80.0,
                                       left: 40.0,
                                       bottom: 200.0,
                                       right: 40.0)
        
        let startStopButtonSize = CGSize(width: 50.0,
                                     height: 50.0)
        let startStopButtonInsets = UIEdgeInsets(top: 0.0,
                                             left: 40.0,
                                             bottom: 40.0,
                                             right: 40.0)
        
        let previosTrackHeight: CGFloat = 28.0
    }
}

final class MainView: UIView {
    
    // MARK: - Private Properties
    private let viewMetrics = ViewMetrics()
    
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var userMarker: GMSMarker?
    
    private var isFollowCoordinates = true
    fileprivate(set) lazy var status: TrackStatus = .start
    
    // MARK: - Public Properties
    weak var delegate: MainViewDelegate?
    
    // MARK: - View Properties
    fileprivate(set) lazy var mainMap: GMSMapView = {
        let view = GMSMapView()
        view.isTrafficEnabled = true
        view.isIndoorEnabled = false
        view.isMyLocationEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate(set) lazy var myLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "location.circle.fill"),
                                  for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self,
                         action: #selector(didTapLocationButton),
                         for: .touchUpInside)
        
        return button
        
        
    }()
    
    fileprivate(set) lazy var startRouteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "play.fill"),
                                  for: .normal)
        button.addTarget(self,
                         action: #selector(didTapStartRoute),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate(set) lazy var loadPreviousRouteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "map.fill"),
                        for: .normal)
        button.setTitle("Previous track",
                        for: .normal)
        button.setTitleColor(.label,
                             for: .normal)
        button.backgroundColor = UIColor.systemBackground
        button.layer.cornerRadius = viewMetrics.previosTrackHeight / 2
        button.layer.masksToBounds = true
        button.addTarget(self,
                         action: #selector(didTapPreviosRoute),
                         for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Object Lifecycle
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureMapStyle()
    }
    
    // MARK: - View actions
    @objc
    private func didTapLocationButton() {
        delegate?.didTapLocationButton()
    }
    
    @objc
    private func didTapStartRoute() {
        delegate?.didTapStartStopButton()
    }
    
    @objc func didTapPreviosRoute() {
        delegate?.didTapPreviosRoute()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        configureMapStyle()
    }
    
    private func addSubviews() {
        addSubview(mainMap)
        addSubview(myLocationButton)
        addSubview(startRouteButton)
        addSubview(loadPreviousRouteButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainMap.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainMap.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            mainMap.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            mainMap.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            myLocationButton.heightAnchor.constraint(equalToConstant: viewMetrics.locationButtonSize.height),
            myLocationButton.widthAnchor.constraint(equalToConstant: viewMetrics.locationButtonSize.width),
            myLocationButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                                    constant: -viewMetrics.locationButtonInsets.right),
            myLocationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -viewMetrics.locationButtonInsets.bottom),
            
            startRouteButton.heightAnchor.constraint(equalToConstant: viewMetrics.startStopButtonSize.height),
            startRouteButton.widthAnchor.constraint(equalToConstant: viewMetrics.startStopButtonSize.width),
            startRouteButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                      constant: 0),
            startRouteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -viewMetrics.startStopButtonInsets.bottom),
            
            loadPreviousRouteButton.heightAnchor.constraint(equalToConstant: viewMetrics.previosTrackHeight),
            loadPreviousRouteButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                         constant: 15),
            loadPreviousRouteButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                             constant: 0)
        ])
    }
    
    private func configureMapStyle() {
        if traitCollection.userInterfaceStyle == .dark {
            guard let styleURL = Bundle.main.url(forResource: "darkGoogleMapsStyleWithourMarkers",
                                                 withExtension: "json") else { return }
            do {
                mainMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } catch {}
        } else {
            guard let styleURL = Bundle.main.url(forResource: "lightGoogleMapsStyleWithoutMarkers",
                                                 withExtension: "json") else { return }
            do {
                mainMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } catch {}
        }
    }
    
    private func configureMapRoute() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = viewMetrics.routePolylineColor
        route?.strokeWidth = viewMetrics.routeStrokeWidth
        
        routePath = GMSMutablePath()
        route?.map = mainMap
    }
    
    private func configureUserMarker() {
        userMarker = GMSMarker()
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.tintColor = viewMetrics.markersColor
        userMarker?.iconView = imageView
        userMarker?.map = mainMap
    }
    
    private func zoomToRoutePath() {
        guard let routePath = routePath else { return }
        mainMap.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: routePath),
                                                  with: viewMetrics.routeInsets))
    }
    
    private func zoomToUser(coordinates: CLLocationCoordinate2D) {
        let position = GMSCameraPosition.camera(withTarget: coordinates,
                                                zoom: 18)
        mainMap.animate(to: position)
    }
    
    private func updateUserPosition(location: CLLocationCoordinate2D) {
        guard userMarker != nil,
            userMarker?.map != nil else {
            configureUserMarker()
            return
        }
        userMarker?.position = location
    }
    
    // MARK: - Public methods
    func updateLocation(location: CLLocationCoordinate2D) {
        updateUserPosition(location: location)
        isFollowCoordinates ?
            zoomToUser(coordinates: location) : zoomToRoutePath()
    }
    
    func zoomToLocationSwitcher(location: CLLocationCoordinate2D) {
        isFollowCoordinates.toggle()
        if isFollowCoordinates {
            myLocationButton.tintColor = .systemRed
            zoomToUser(coordinates: location)
        } else {
            myLocationButton.tintColor = .systemBlue
            zoomToRoutePath()
        }
    }
    
    func setStatus(status: TrackStatus) {
        self.status = status
    }
    
    func setStartMarker(location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        let imageView = UIImageView(image: UIImage(systemName: "flag.circle.fill"))
        imageView.tintColor = viewMetrics.startPointColor
        marker.snippet = "Was here at \(Date().description(with: .current))"
        
        marker.iconView = imageView
        marker.map = mainMap
    }
    
    func addRoutePoint(point: CLLocationCoordinate2D) {
        if let route = route, let routePath = routePath {
            routePath.add(point)
            route.path = routePath
        } else {
            configureMapRoute()
            setStartMarker(location: point)
            routePath?.add(point)
            route?.path = routePath
        }
    }
    
    func setFinishMarker(location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        let imageView = UIImageView(image: UIImage(systemName: "flag.circle.fill"))
        imageView.tintColor = viewMetrics.finishPointColor
        marker.snippet = "Was here at \(Date().description(with: .current))"
        
        marker.iconView = imageView
        marker.map = mainMap
    }
    
    func clearMap(complition: () -> Void) {
        mainMap.clear()
        userMarker = nil
        route = nil
        routePath = nil
    }
    
    func setRoute(route: [CLLocationCoordinate2D]){
        mainMap.clear()
        configureMapRoute()
        
        setStartMarker(location: route.first!)
        setFinishMarker(location: route.last!)
        route.forEach { point in
            routePath?.add(point)
        }
        self.route?.path = routePath
        
        if isFollowCoordinates {
            isFollowCoordinates.toggle()
            myLocationButton.tintColor = .systemBlue
            zoomToRoutePath()
        }
    }
}
