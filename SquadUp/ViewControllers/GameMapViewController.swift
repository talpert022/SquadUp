//
//  GameMapViewController.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/4/20.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

struct globalVars {
    static var games = [Game]()
}

class GameMapViewController: UIViewController, GameCreatedDelegate {
    
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet weak var centerLocation: UIButton!
    @IBOutlet weak var createGame: UIButton!
    
    let locationManager = CLLocationManager()
    
    let regionInMeters : Double = 10000
    var currentLocationStr = "Current location"
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        checkLocationServices()
        
        mapView.delegate = self
        mapView.userTrackingMode = .none
        
        refresh()
        addAnnotations()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAnnotations(notification:)), name: NSNotification.Name(rawValue: "dismissed"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private Methods
    
    private func refresh() {
        _ = Game.fetchRequest() as NSFetchRequest<Game>
        do {
            globalVars.games = try context.fetch(Game.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func addAnnotations() {
        mapView.addAnnotations(globalVars.games)
    }
    
    @objc func refreshAnnotations(notification: NSNotification) {
        mapView.addAnnotation(globalVars.games[globalVars.games.count-1])
    }
    
    // MARK: - Helpers
    func customizeUI() {
        createGame.layer.cornerRadius = 24
        centerLocation.layer.cornerRadius = 24
    }
    
    
    // MARK: - Actions
    
    @IBAction func centerLocationPressed(_ sender: Any) {
        centerViewOnUserLocation()
    }
    
    
    @IBAction func createGamePressed(_ sender: UIButton) {
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [FirstGameViewController()]
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func addNewGame(location: CLLocationCoordinate2D, sport: String, date: Date, eventDescription : String?) {
        let newGame = Game(entity: Game.entity(), insertInto: context)
        newGame.latitude = location.latitude
        newGame.longitude = location.longitude
        newGame.title = sport
        newGame.date = date
        newGame.eventDescription = eventDescription
        globalVars.games.append(newGame)
        appDelegate.saveContext()
        refresh()
    }
    

}
// MARK: - Location Manager
extension GameMapViewController : CLLocationManagerDelegate {
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("Location services are off")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing user to allow location
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show restricted alert
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError("Deprecated Constant")
        }
    }
    
}

// MARK: - Map Kit

extension GameMapViewController : MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        // Verify annotatoin
        guard let annotation = annotation as? Game else {
            return nil
        }
        // Create identifier and view
        let identifier = "game"
        var view: GameView
        // New view if it doesn't already exist
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? GameView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = GameView(
                annotation: annotation,
                reuseIdentifier: identifier)
        }
        // Create multiline subtitle view
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        
        let attributedText = NSMutableAttributedString(string: subtitleView.text!)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 26))
        
        subtitleView.attributedText = attributedText
        view.detailCalloutAccessoryView = subtitleView
        
        return view
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let artwork = view.annotation as? Game else {
            return
        }
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}

