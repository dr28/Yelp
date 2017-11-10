//
//  MapViewController.swift
//  Yelp
//
//  Created by Deepthy on 9/23/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import MapKit
import CoreLocation
import ACProgressHUD_Swift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var redoSearchButton: UIButton!
    
    fileprivate var center: CLLocationCoordinate2D!
    fileprivate var annotations: [MKPointAnnotation]!
    fileprivate let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
    fileprivate lazy var locationManager = self.makeLocationManager()
   
    var filters: [String: AnyObject]!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationController!.navigationBar.barTintColor = ThemeManager.currentTheme().mainColor
        navigationController!.navigationBar.tintColor = ThemeManager.currentTheme().backgroundColor

        mapView.delegate = self
        mapView.tintColor = UIColor.blue.withAlphaComponent(0.7)

        redoSearchButton.layer.cornerRadius = 5.0
        redoSearchButton.layer.masksToBounds = true
        redoSearchButton.isHidden = true

        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: centerLocation.coordinate.latitude, longitude: centerLocation.coordinate.longitude)
        
        annotation.coordinate = coordinate
        goToLocation(location: centerLocation)

        if self.businesses.count == 0 {
            let center = centerLocation.coordinate

            let span = MKCoordinateSpanMake(0.05, 0.05)
            mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
        }
        else {
            addAnnotationFor(businesses: businesses)
        }
    }
    
    private func makeLocationManager() -> CLLocationManager {
        var locationManager = CLLocationManager()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()

        return locationManager
    }
    
    fileprivate func makeSpanRegion()
    {
        var miles: Double = 5.0

        if let distInMeters = filters[Constants.filterDistance] {
            var distInMiles = Double.init(distInMeters as! NSNumber) * 0.000621371
            distInMiles = Constants.rounded(no: distInMiles, toPlaces: 1)
            
            if distInMiles > miles {
                miles = distInMiles
            }
        }
        
        print("miles \(miles)")

        let scalingFactor: Double = abs( (cos(2 * M_PI * centerLocation.coordinate.latitude / 360.0) ))

        var span = MKCoordinateSpan()
        span.latitudeDelta = miles/69.0
        span.longitudeDelta = miles/(scalingFactor * 69.0)

        var region = MKCoordinateRegion()
        region.span = span
        region.center = centerLocation.coordinate
        
        mapView.setRegion(region, animated: true)
    }
    
    func performSearch(_ term: String) {
        filters[Constants.filterTerm] = term as AnyObject
        
        Business.searchWithTerm(term: term, sort: nil, categories: [Constants.restaurants.lowercased()], deals: nil, distance: 0, offset: nil) { (businesses: [Business]?, errror: Error?) in
            
            if let businesses = businesses {
                self.businesses = businesses
            
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.redoSearchButton.isHidden = true
            
                self.addAnnotationFor(businesses: businesses)
                ACProgressHUD.shared.hideHUD()
            }
        }
    }

    private func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    @IBAction func onRedoSearchButton(_ sender: Any) {
        let progressView = ACProgressHUD.shared
        progressView.progressText = Constants.progressText
        progressView.showHudAnimation = .growIn
        
        progressView.showHUD()
        self.performSearch(searchBar.text!)
    }
    
    func showDetailsFor(_ business: Business) {
        
        let storyboard = UIStoryboard(name: Constants.main, bundle: Bundle.main)

        let controller = storyboard.instantiateViewController(withIdentifier: Constants.detailsReuseIdentifier) as! DetailViewController
        controller.business = business
        controller.filters = filters

        navigationController?.pushViewController(controller, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == Constants.segueMapFilterIdentifier {
            
            let navigationController = segue.destination as! UINavigationController
            
            let filterViewController = navigationController.topViewController as! FiltersViewController
            filterViewController.delegate = self
            searchBar.text = ""
            filters[Constants.filterTerm] = "" as AnyObject
            filterViewController.filters = filters
        }
        else if segue.identifier == Constants.segueListSearchIdentifier {
            
            let listViewController = (segue.destination as! UINavigationController).topViewController as! BusinessesViewController
            
            listViewController.businesses = businesses
            listViewController.filters = filters
            listViewController.searchBar = searchBar
        }
    }
}

// MARK: - Map View Delegate methods
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.pinIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.pinIdentifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
            
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let index = (self.annotations as NSArray).index(of: view.annotation)
        
        if index >= 0 {
            self.showDetailsFor(self.businesses[index])
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if self.center == nil {
            self.center = mapView.region.center
        } else {
            let before = CLLocation(latitude: self.center.latitude, longitude: self.center.longitude)
            let nowCenter = mapView.region.center
            let now = CLLocation(latitude: nowCenter.latitude, longitude: nowCenter.longitude)
            //centerLocation = now //cannot display result for new location, YelpClient has location hardcorded
            self.redoSearchButton.isHidden = self.searchBar.text == "" || before.distance(from: now) < 100
        }
    }
}

// MARK: - Location Manager Delegate methods
extension MapViewController: CLLocationManagerDelegate {
    
    func addAnnotationFor(businesses: [Business]) {
        
        makeSpanRegion()
        
        annotations = []
        mapView.removeAnnotations(self.mapView.annotations)
        
        for business in businesses {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longtitude!)
            annotation.coordinate = coordinate
            annotation.title = business.name
            annotation.subtitle = business.categories
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
}

// MARK: - SearchBar Delegate methods
extension MapViewController: UISearchBarDelegate {
    
    final func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let progressView = ACProgressHUD.shared
        progressView.progressText = Constants.progressText
        progressView.showHudAnimation = .growIn
        progressView.showHUD()
        
        self.performSearch(searchBar.text!)
    }
}

// MARK: - Filter Delegate methods
extension MapViewController: FiltersViewControllerDelegate {
    
    func filterMapViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        self.filters = filters
        let categories = filters[Constants.filterCategories] as? [String]
        let deals = filters[Constants.filterDeals] as? Bool
        let sort = filters[Constants.filterSort] as? Int
        let distance = filters[Constants.filterDistance] as? Int

        Business.searchWithTerm(term: Constants.restaurants, sort: YelpSortMode(rawValue: sort!)!, categories:  categories, deals: deals, distance: distance!, offset: nil) { (businesses: [Business]?, errror: Error?) in
            if let businesses = businesses {

                self.businesses = businesses
                self.addAnnotationFor(businesses: self.businesses)
            }
        }
    }
}
