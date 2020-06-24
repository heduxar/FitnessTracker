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
}

extension MainView {
    struct ViewMetrics {
        let locationButtonSize = CGSize(width: 32, height: 32)
        let locationButtonInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 8.0)
        let markersColor = UIColor.systemIndigo
    }
}

final class MainView: UIView {
    
    // MARK: - Private Properties
    private let viewMetrics = ViewMetrics()
    
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
        button.tintColor = viewMetrics.markersColor
        button.addTarget(self,
                         action: #selector(didTapLocationButton),
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
        setupView()
    }
    
    // MARK: - View actions
    @objc
    private func didTapLocationButton() {
        delegate?.didTapLocationButton()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        if traitCollection.userInterfaceStyle == .dark {
            guard let styleURL = Bundle.main.url(forResource: "darkGoogleMapsStyleWithourMarkers", withExtension: "json") else { return }
            do {
                mainMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } catch {}
        } else {
            guard let styleURL = Bundle.main.url(forResource: "lightGoogleMapsStyleWithoutMarkers", withExtension: "json") else { return }
            do {
                mainMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } catch {}
        }
        
    }
    
    private func addSubviews() {
        addSubview(mainMap)
        addSubview(myLocationButton)
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
                                                     constant: -viewMetrics.locationButtonInsets.bottom)
        ])
    }
    
    // MARK: - Public methods
    func updateLocation(location: CLLocationCoordinate2D) {
        let position = GMSCameraPosition.camera(withTarget: location,
                                                  zoom: 18)
        mainMap.animate(to: position)
        setMarker(location: location)
    }
    
    func currentLocation(location: CLLocationCoordinate2D) {
        let position = GMSCameraPosition.camera(withTarget: location,
                                                  zoom: 18)
        mainMap.animate(to: position)
    }
    
    func setMarker(location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.tintColor = viewMetrics.markersColor
        marker.snippet = "Was here at \(Date().description(with: .current))"
        
        marker.iconView = imageView
        marker.map = mainMap
    }
}
