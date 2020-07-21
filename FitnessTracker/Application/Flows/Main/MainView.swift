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
    func didTapExit()
}

enum TrackStatus {
    case start, progress, finish
}

enum FollowStatus {
    case none, user, route, previousRoute
}

extension MainView {
    struct ViewMetrics {
        let backgroundColor = UIColor.systemBackground
    
        let markersColor = UIColor.systemBlue
        let markersSize = CGSize(width: 24.0, height: 24.0)
        let startPointColor = UIColor.systemGreen
        let finishPointColor = UIColor.systemRed
        let routePolylineColor = UIColor.systemBlue
        let routeStrokeWidth: CGFloat = 3
        
        let buttonSize = CGSize(width: 44.0,
                                height: 44.0)
        var buttonsCR:CGFloat { buttonSize.height / 2 }
        
        let buttonsStackSpacing: CGFloat = 8.0
        let buttonsStackInsets = UIEdgeInsets(top: 0.0,
                                              left: 28.0,
                                              bottom: 28.0,
                                              right: 28.0)
        
        let startStopButtonInsets = UIEdgeInsets(top: 0.0,
                                                 left: 0.0,
                                                 bottom: 28.0,
                                                 right: 0.0)
        let exitButtonSize = CGSize(width: 28.0,
                                    height: 28.0)
        let exitButtonInsets = UIEdgeInsets(top: 4.0,
                                            left: 4.0,
                                            bottom: 0.0,
                                            right: 0.0)
        
        let locationButtonImageName = "scope"
        let routeButtonImageName = "arrow.swap"
        let previosRouteImageName = "map"
        let startTrackButtonImageName = "play.fill"
        let stopTrackButtonImageName = "stop.fill"
        let userMarkImageName = "mappin.and.ellipse"
        let flagMarkImageName = "flag.circle.fill"
    }
}

final class MainView: UIView {
    // MARK: - Private Properties
    private let viewMetrics = ViewMetrics()
    
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var userMarker: GMSMarker?
    
    private var followStatus: FollowStatus = .user {
        didSet {
            followStatusChanged()
        }
    }
    fileprivate(set) lazy var status: TrackStatus = .start
    
    // MARK: - Public Properties
    weak var delegate: MainViewDelegate?
    
    // MARK: - View Properties
    fileprivate(set) lazy var mainMap: GMSMapView = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isTrafficEnabled = true
        view.isIndoorEnabled = false
        view.isBuildingsEnabled = false
        view.isMyLocationEnabled = false
        view.settings.rotateGestures = true
        
        return view
    }()
    
    fileprivate(set) lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "icon_close"),
                                  for: .normal)
        button.backgroundColor = UIColor.systemBackground
        button.tintColor = UIColor.label
        button.layer.frame.size = viewMetrics.exitButtonSize
        button.layer.cornerRadius = viewMetrics.exitButtonSize.height / 2
        button.layer.masksToBounds = true
        button.addTarget(self,
                         action: #selector(didTapExit),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate(set) lazy var myLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = viewMetrics.backgroundColor
        button.setBackgroundImage(UIImage(systemName: viewMetrics.locationButtonImageName),
                                  for: .normal)
        button.layer.cornerRadius = viewMetrics.buttonsCR
        button.layer.masksToBounds = true
        button.tintColor = .systemRed
        button.addTarget(self,
                         action: #selector(didTapLocationButton),
                         for: .touchUpInside)
        
        return button
    }()
    
    fileprivate(set) lazy var routeLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = viewMetrics.backgroundColor
        button.setBackgroundImage(UIImage(systemName: viewMetrics.routeButtonImageName),
                                  for: .normal)
        button.layer.cornerRadius = viewMetrics.buttonsCR
        button.layer.masksToBounds = true
        button.tintColor = .systemBlue
        button.addTarget(self,
                         action: #selector(didTapRouteButton),
                         for: .touchUpInside)
        
        return button
    }()
    
    fileprivate(set) lazy var startRouteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: viewMetrics.startTrackButtonImageName),
                                  for: .normal)
        button.addTarget(self,
                         action: #selector(didTapStartRoute),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate(set) lazy var loadPreviousRouteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = viewMetrics.backgroundColor
        button.setImage(UIImage(systemName: viewMetrics.previosRouteImageName),
                        for: .normal)
        button.layer.cornerRadius = viewMetrics.buttonsCR
        button.layer.masksToBounds = true
        button.tintColor = .systemBlue
        button.addTarget(self,
                         action: #selector(didTapPreviosRoute),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate(set) lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = viewMetrics.buttonsStackSpacing
        stack.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stack
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
        myLocationButton.tintColor = .systemRed
        routeLocationButton.tintColor = .systemBlue
        followStatus = followStatus != .user ? .user : .none
        delegate?.didTapLocationButton()
    }
    
    @objc
    private func didTapStartRoute() {
        delegate?.didTapStartStopButton()
    }
    
    @objc
    private func didTapPreviosRoute() {
        followStatus != .previousRoute ?
            delegate?.didTapPreviosRoute() : nil
    }
    
    @objc
    private func didTapRouteButton() {
        zoomToRoutePath()
        myLocationButton.tintColor = .systemBlue
        routeLocationButton.tintColor = .systemRed
        followStatus = followStatus != .route ? .route : .none
    }
    
    @objc
    private func didTapExit() {
        delegate?.didTapExit()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        configureMapStyle()
    }
    
    private func addSubviews() {
        addSubview(mainMap)
        addSubview(buttonsStack)
        addSubview(exitButton)
        buttonsStack.addArrangedSubview(loadPreviousRouteButton)
        buttonsStack.addArrangedSubview(routeLocationButton)
        buttonsStack.addArrangedSubview(myLocationButton)
        addSubview(startRouteButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainMap.topAnchor.constraint(equalTo: topAnchor),
            mainMap.leftAnchor.constraint(equalTo: leftAnchor),
            mainMap.rightAnchor.constraint(equalTo: rightAnchor),
            mainMap.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            exitButton.widthAnchor.constraint(equalToConstant: viewMetrics.exitButtonSize.width),
            exitButton.heightAnchor.constraint(equalToConstant: viewMetrics.exitButtonSize.height),
            exitButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor,
                                            constant: viewMetrics.exitButtonInsets.top),
            exitButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor,
                                             constant: viewMetrics.exitButtonInsets.left),
            
            buttonsStack.rightAnchor.constraint(equalTo: rightAnchor,
                                                constant: -viewMetrics.buttonsStackInsets.right),
            buttonsStack.bottomAnchor.constraint(equalTo: startRouteButton.topAnchor,
                                                 constant: -viewMetrics.buttonsStackInsets.bottom),
            
            myLocationButton.heightAnchor.constraint(equalToConstant: viewMetrics.buttonSize.height),
            myLocationButton.widthAnchor.constraint(equalToConstant: viewMetrics.buttonSize.width),
            
            routeLocationButton.heightAnchor.constraint(equalToConstant: viewMetrics.buttonSize.height),
            routeLocationButton.widthAnchor.constraint(equalToConstant: viewMetrics.buttonSize.width),
            
            loadPreviousRouteButton.heightAnchor.constraint(equalToConstant: viewMetrics.buttonSize.height),
            loadPreviousRouteButton.widthAnchor.constraint(equalToConstant: viewMetrics.buttonSize.width),
            
            startRouteButton.heightAnchor.constraint(equalToConstant: viewMetrics.buttonSize.height),
            startRouteButton.widthAnchor.constraint(equalToConstant: viewMetrics.buttonSize.width),
            startRouteButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                      constant: 0),
            startRouteButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                     constant: -viewMetrics.startStopButtonInsets.bottom)
        ])
    }
    
    private func followStatusChanged() {
        switch followStatus {
        case .none:
            myLocationButton.tintColor = .systemBlue
            routeLocationButton.tintColor = .systemBlue
            loadPreviousRouteButton.tintColor = .systemBlue
        case .route:
            myLocationButton.tintColor = .systemBlue
            routeLocationButton.tintColor = .systemRed
            loadPreviousRouteButton.tintColor = .systemBlue
        case .user:
            myLocationButton.tintColor = .systemRed
            routeLocationButton.tintColor = .systemBlue
            loadPreviousRouteButton.tintColor = .systemBlue
        case .previousRoute:
            myLocationButton.tintColor = .systemBlue
            routeLocationButton.tintColor = .systemBlue
            loadPreviousRouteButton.tintColor = .systemRed
        }
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
        guard let user = try? RealmProvider.get(RealmUserModel.self)
            .first(where: { $0.id == UserDefaults.standard.isLoginedUserID }),
            !user.userAvatar.isEmpty,
            let image = UIImage(data: user.userAvatar)
            else {
                userMarker = GMSMarker()
                let imageView = UIImageView(image: UIImage(named: "avatar_placeholder"))
                imageView.frame.size = viewMetrics.markersSize
                imageView.tintColor = viewMetrics.markersColor
                userMarker?.iconView = imageView
                userMarker?.map = mainMap
                return
        }
        userMarker = GMSMarker()
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = viewMetrics.markersColor.cgColor
        imageView.frame.size = viewMetrics.markersSize
        imageView.layer.cornerRadius = viewMetrics.markersSize.height / 2
        imageView.layer.masksToBounds = true
        userMarker?.iconView = imageView
        userMarker?.map = mainMap
    }
    
    private func zoomToRoutePath() {
        guard let routePath = routePath else { return }
        let routeInsets = UIEdgeInsets(top: 28.0,
                                       left: 28.0,
                                       bottom: (bounds.height - buttonsStack.frame.maxY),
                                       right: 28.0)
        mainMap.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: routePath),
                                                  with: routeInsets))
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
    func updateLocation(location: CLLocationCoordinate2D?) {
        guard let location = location else { return }
        updateUserPosition(location: location)
        switch followStatus {
        case .none:
            break
        case .user:
            zoomToUser(coordinates: location)
        case .route:
            zoomToRoutePath()
        case .previousRoute:
            break
        }
    }
    
    func setStatus(status: TrackStatus) {
        self.status = status
        switch status {
        case .start:
            startRouteButton.setBackgroundImage(UIImage(systemName: viewMetrics.startTrackButtonImageName),
                                                for: .normal)
        case .progress:
            startRouteButton.setBackgroundImage(UIImage(systemName: viewMetrics.stopTrackButtonImageName),
                                                for: .normal)
            
        case .finish:
            break
        }
    }
    
    func setStartMarker(location: CLLocationCoordinate2D, date: Date? = nil) {
        let marker = GMSMarker(position: location)
        let imageView = UIImageView(image: UIImage(systemName: viewMetrics.flagMarkImageName))
        imageView.frame.size = viewMetrics.markersSize
        imageView.tintColor = viewMetrics.startPointColor
        marker.snippet = "Start here at \(date?.description(with: .current) ?? "unknown")"
        
        marker.iconView = imageView
        marker.map = mainMap
    }
    
    func addRoutePoint(point: CLLocationCoordinate2D) {
        if let route = route,
            let routePath = routePath {
            routePath.add(point)
            route.path = routePath
        } else {
            configureMapRoute()
            setStartMarker(location: point)
            routePath?.add(point)
            route?.path = routePath
        }
    }
    
    func setFinishMarker(location: CLLocationCoordinate2D, date: Date? = nil) {
        let marker = GMSMarker(position: location)
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: viewMetrics.flagMarkImageName)
        imageView.frame.size = CGSize(width: 25.0, height: 25.0)
        imageView.tintColor = viewMetrics.finishPointColor
        marker.snippet = "Ended here at \(date?.description(with: .current) ?? "unknown")"
        
        marker.iconView = imageView
        marker.map = mainMap
    }
    
    func clearMap(complition: () -> Void) {
        mainMap.clear()
        userMarker = nil
        route = nil
        routePath = nil
    }
    
    func setRoute(route: RealmTrackModel){
        mainMap.clear()
        configureMapRoute()
        setStartMarker(location: route.locationPoints.first!.coordinate,
                       date: route.startTime)
        
        setFinishMarker(location: route.locationPoints.last!.coordinate,
                        date: route.endTime)
        
        route.locationPoints.forEach { point in
            routePath?.add(point.coordinate)
        }
        
        self.route?.path = routePath
        
        followStatus = .previousRoute
        zoomToRoutePath()
    }
}
