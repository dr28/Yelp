//
//  DetailViewController.swift
//  Yelp
//
//  Created by Deepthy on 9/22/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet private weak var businessImgView: UIImageView!
    @IBOutlet private weak var businessLabel: UILabel!
    @IBOutlet private weak var businessMapView: MKMapView!
    @IBOutlet private weak var ratingsImg: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var ratingsLabel: UILabel!
    
    fileprivate let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
    fileprivate lazy var locationManager = self.makeLocationManager()

    var business:Business?
    var filters: [String: AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        businessImgView.setImageWith((business?.imageURL!)!)
        businessLabel.text = business?.name
        ratingsImg.setImageWith((business?.ratingImageURL!)!)
                
        let reviewsCountLabel = business?.reviewCount! == 1 ? "\((business?.reviewCount!)!) \(Constants.reviewLabel)" : "\((business?.reviewCount!)!) \(Constants.reviewsLabel)"
        
        ratingsLabel.tintColor = ThemeManager.currentTheme().secondaryColor
        categoryLabel.tintColor = ThemeManager.currentTheme().secondaryColor

        ratingsLabel.text = String(describing: reviewsCountLabel)
        addressLabel.text = business?.address
        categoryLabel.text = business?.categories
        navigationController!.navigationBar.barTintColor = ThemeManager.currentTheme().mainColor
        navigationController!.navigationBar.tintColor = ThemeManager.currentTheme().backgroundColor
        
        businessMapView.tintColor = UIColor.blue.withAlphaComponent(0.7)
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: centerLocation.coordinate.latitude, longitude: centerLocation.coordinate.longitude)

        self.businessMapView.addAnnotation(annotation)
        self.businessMapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: false)
        self.businessMapView.layer.cornerRadius = 9.0
        self.businessMapView.layer.masksToBounds = true

        goToLocation(location: centerLocation)
        addAnnotationAtAddress(address: (business?.address)!, title: (business?.name)!)
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

    
    private func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        businessMapView.setRegion(region, animated: false)
    }
    
    private func makeSpanRegion()
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
        
        businessMapView.setRegion(region, animated: true)
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
            businessMapView.setRegion(region, animated: false)
        }
    }
    
    // add an annotation with an address: String
    private func addAnnotationAtAddress(address: String, title: String) {
        makeSpanRegion()

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    annotation.subtitle = address
                    self.businessMapView.addAnnotation(annotation)
                }
            }
        }
    }
}

// MARK: - MapView Delegate methods
extension BusinessesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.pinIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.pinIdentifier)
        }
        else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
