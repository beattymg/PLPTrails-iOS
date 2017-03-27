//
//  ViewController.swift
//  PLPTrails
//
//  Created by Matthew Beatty on 12/30/15.
//  Copyright (c) 2015 Matthew Beatty. All rights reserved.
//

import UIKit
import Mapbox
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    fileprivate var userLocation:MGLUserLocation!
    internal var kmlParser:KMLParser!
    var locationManager:CLLocationManager!
    var manager: OneShotLocationManager?
    
    fileprivate var coordinateArray: [[(Double, Double)]] = []
    fileprivate var trailNameArray: [String] = []
    
    @IBOutlet var filterCoursesButton: UIButton!
    @IBOutlet var topBarView: UIView!
    @IBOutlet var currentTrailLabel: UILabel!
    
    var previousLat:Double = 0.0
    var previousLong:Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.locationManager.delegate = self
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.startUpdatingLocation()
        
        // fill in the next line with your style URL from Mapbox Studio
        let styleURL = URL(string: "mapbox://styles/beattymg/ciiug67uw00izzwmag6e6l10d")
        let mapView = MGLMapView(frame: view.bounds,
            styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let checkUserLocation = mapView.userLocation {
            checkUserLocation.title = "User location marker"
            mapView.addAnnotation(checkUserLocation)
            mapView.setCenter(CLLocationCoordinate2D(latitude: checkUserLocation.coordinate.latitude,
                longitude: checkUserLocation.coordinate.longitude),
                zoomLevel: 12, animated: false)
            userLocation = mapView.userLocation!
            print("there's a user location")
            
        }
        else {
            mapView.setCenter(CLLocationCoordinate2D(latitude: 41.1,
                longitude: -75.530),
                zoomLevel: 12, animated: false)
        }
        
        // set the map's center coordinate
        
        
        view.addSubview(mapView)
        mapView.delegate = self
        
        
        loadOfflineCache()
        
        let firstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
        if firstLaunch  {
            print("Not first launch.")
            loadTrailBar()
        }
        else {
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
            loadTrailBar()
            //
        }
        
        currentTrailLabel.text = "Powerline Trail"
        findClosestTrail()
        updateCurrentTrail()
        view.bringSubview(toFront: topBarView)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.updateCurrentTrail), userInfo: nil, repeats: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            if let _ = location {
                print(location)
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
    }
    
    func loadTrailBar() {
        loadTrailData()
        
    }
    
    func loadTrailData() {
        let path1 = Bundle.main.path(forResource: "TrailData082615", ofType: "kml")
        let url = URL(fileURLWithPath: path1!)
        self.kmlParser = KMLParser(url: url)
        print(self.kmlParser.overlays)
        print(self.kmlParser.points)
        
        let path = Bundle.main.path(forResource: "TrailDataGeoJSON", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = JSON(data: jsonData!)
        
        for item in json["features"].arrayValue {
            var tempCoordinateArray = [(Double, Double)]()
            for coordinate in item["geometry"]["coordinates"].arrayValue {
                tempCoordinateArray.append((coordinate[0].stringValue as NSString).doubleValue, (coordinate[1].stringValue as NSString).doubleValue)
            }
            coordinateArray.append(tempCoordinateArray)
            trailNameArray.append(item["properties"]["name"].stringValue)
        }
        
        print(coordinateArray);
    }
    
    func loadOfflineCache() {
        
        
    }
    
    func findClosestTrail() {
        var tempLat:Double = 0.0
        var tempLong:Double = 0.0
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            if let _ = location {
                print(location)
                tempLat = (location?.coordinate.latitude.distance(to: 0.0))!
                tempLong = (location?.coordinate.longitude.distance(to: 0.0))!
                abs(tempLat)
                abs(tempLong)
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
        for coordinateTuple in coordinateArray {
            //check if it is near current position
        }
        
    }
    
    func updateCurrentTrail() {
        var tempLat:Double = 0.0
        var tempLong:Double = 0.0
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            if let _ = location {
                print(location)
                tempLat = (location?.coordinate.latitude.distance(to: 0.0))!
                tempLong = (location?.coordinate.longitude.distance(to: 0.0))!
                abs(tempLat)
                abs(tempLong)
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
        if (abs(tempLat - previousLat) > 0.001 || abs(tempLat - previousLat) > 0.001)
        {
            
            
            
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.description)")
        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "Ok")
        errorAlert.show()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let newLocation = locations.last as! CLLocation
        //print("current position: \(newLocation.coordinate.longitude) , \(newLocation.coordinate.latitude)")
    }

}

