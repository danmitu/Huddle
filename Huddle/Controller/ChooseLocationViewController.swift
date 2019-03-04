//
//  ChooseLocationViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/31/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// Allows the user to select a location on a map. They make a location by tapping on the screen for 0.5 seconds. This will drop a placemark for the selection. If no location is selected then the user's current location will be used. If there is no selection and the user hasn't provided their location, pressing the "Select" button will display a `UIAlert` error. Upon tapping "Select", `whenDoneSelecting` will be called passing in the selected location.
class ChooseLocationViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private let locationManager = CLLocationManager()
    
    /// The currently selected location.
    private var selectedLocationAnnotation: MKPointAnnotation?
    
    /// Called when the user has selected a location.
    var whenDoneSelecting: ((CLPlacemark)->())?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectionLocationButtonPressed)), animated: false)
        self.view = mapView
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        self.locationManager.startUpdatingLocation()
        
    }
    
    // MARK: - Methods
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            let touchPoint: CGPoint = gestureRecognizer.location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            addAnnotationOnLocation(pointedCoordinate: newCoordinate)
        default: break
        }
    }
    
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        if selectedLocationAnnotation != nil {
            mapView.removeAnnotation(selectedLocationAnnotation!)
        }
        annotation.coordinate = pointedCoordinate
        selectedLocationAnnotation = annotation
        mapView.addAnnotation(annotation)
    }
    
    @objc private func selectionLocationButtonPressed() {
        guard let selectedCoordinates = selectedLocationAnnotation?.coordinate ?? locationManager.location?.coordinate else {
            OkPresenter.init(title: "Error Selecting Location", message: "You must either select a location by tapping on the map, or share your current location.", handler: {}).present(in: self)
            return
        }
        
        let selectedLocation = CLLocation(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude)
        
        CLGeocoder().reverseGeocodeLocation(selectedLocation, completionHandler: { [weak self] (placemarks, error) -> Void in
            guard error == nil else { return }
            guard let placemark = placemarks?.first else { return }
            self?.whenDoneSelecting?(placemark)
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    
}
