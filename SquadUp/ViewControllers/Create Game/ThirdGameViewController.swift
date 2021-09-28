//
//  ThirdGameViewController.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/6/20.
//

import UIKit
import MapKit
import CoreLocation

protocol GameCreatedDelegate: NSObjectProtocol {
    func addNewGame(location: CLLocationCoordinate2D, sport: String, date: Date, eventDescription : String?)
}

class ThirdGameViewController: UIViewController {
    
    // MARK: - Variables and Outlets
    
    var delegate : GameCreatedDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var createGame: UIButton!
    @IBOutlet weak var instructionLabelTopConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    let regionInMeters: CLLocationDistance = CLLocationDistance(10000)
    let pinIdentifier = "Game Pin"
    var gameAnnotation : MKAnnotation? = nil
    var date : Date = Date()
    var sport : String = ""
    var eventDescription: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapandLocation()
        customizeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavBar()
    }
    
    // MARK: - Actions
    
    @objc func cancelGame() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createGamePressed(_ sender: Any) {
        
        guard gameAnnotation != nil else {
            let alert = UIAlertController(title: "No Game Location", message: "Please choose a game location before proceeding", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Adds new game to data
        if let delegate = delegate {
            delegate.addNewGame(location: gameAnnotation!.coordinate, sport: sport, date: date, eventDescription: eventDescription)
        }
        
        // Tells map view to update with new annotation
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissed"), object: nil)
        
        // Dismisses create game nav controller
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Select Location"
        navigationController?.navigationBar.topItem?.prompt = "3 of 3"
        
        // Right cancel button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelGame))
        let textAttribute2 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "HelveticaNeue-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        let textAttribute3 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray, .font: UIFont(name: "HelveticaNeue-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute2, for: .normal)
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute3, for: .selected)
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func customizeUI() {
        
        instructionLabel.layer.masksToBounds = true
        instructionLabel.layer.cornerRadius = 20
        instructionLabel.textColor = .black
        createGame.layer.borderWidth = 3
        createGame.layer.borderColor = UIColor.black.cgColor
        createGame.layer.cornerRadius = 10
        createGame.backgroundColor = UIColor.green.darker(by: 5)
    }
    
    func configureMapandLocation() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
        
        mapView.addGestureRecognizer(myLongPress)
        
    }
    /*
     func addGamePin() {
     
     let setGame : MKAnnotation = gamePin(coordinate: locationManager.location!.coordinate, title: sport)
     gameAnnotation = setGame
     mapView.addAnnotation(setGame)
     
     }
     */
    
    // A method called when long press is detected.
    @objc private func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
        // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        // Clear other pin from map
        if gameAnnotation != nil {
            mapView.removeAnnotation(gameAnnotation!)
        }
        // Get the coordinates of the point you pressed long.
        let location = sender.location(in: mapView)
        
        // Convert location to CLLocationCoordinate2D.
        let myCoordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Generate pins.
        let myPin: MKAnnotation = gamePin(coordinate: myCoordinate, title: sport)
        
        // Added pins to MapView.
        mapView.addAnnotation(myPin)
        
        // Assign game location to pin
        gameAnnotation = myPin
    }
    
    
}

// MARK: - Map Kit
extension ThirdGameViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            view.setDragState(.dragging, animated: true)
        case .canceling, .ending:
            view.setDragState(.none, animated: true)
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? gamePin else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            //  annotationView?.image = UIImage(named: "pin")
            annotationView!.isDraggable = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}
