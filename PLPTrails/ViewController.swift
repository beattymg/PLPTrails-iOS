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
    
    private var userLocation:MGLUserLocation!
    internal var kmlParser:KMLParser!
    var locationManager:CLLocationManager!
    
    private var coordinateArray: [[(Double, Double)]] = []
    private var trailNameArray: [String] = []
    
    @IBOutlet var filterCoursesButton: UIButton!
    @IBOutlet var topBarView: UIView!
    @IBOutlet var currentTrailLabel: UILabel!
    
    var previousLat:Double = 0.0
    var previousLong:Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        // fill in the next line with your style URL from Mapbox Studio
        let styleURL = NSURL(string: "mapbox://styles/beattymg/ciiug67uw00izzwmag6e6l10d")
        let mapView = MGLMapView(frame: view.bounds,
            styleURL: styleURL)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        if let checkUserLocation = mapView.userLocation {
            checkUserLocation.title = "USER LOCATION MARKER"
            mapView.addAnnotation(checkUserLocation)
            mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: checkUserLocation.coordinate.latitude,
                longitude: checkUserLocation.coordinate.longitude),
                zoomLevel: 12, animated: false)
            userLocation = mapView.userLocation!
            print("there's a user location")
            
        }
        else {
            mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 41.1,
                longitude: -75.530),
                zoomLevel: 12, animated: false)
        }
        
        // set the map's center coordinate
        
        
        view.addSubview(mapView)
        mapView.delegate = self
        
        
        loadOfflineCache()
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        if firstLaunch  {
            print("Not first launch.")
            loadTrailBar()
        }
        else {
            print("First launch, setting NSUserDefault.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            loadTrailBar()
            //
        }
        
        updateCurrentTrail()
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateCurrentTrail", userInfo: nil, repeats: true)

    }
    
    func loadTrailBar() {
        loadTrailData()
        
    }
    
    func loadTrailData() {
        let path1 = NSBundle.mainBundle().pathForResource("TrailData082615", ofType: "kml")
        let url = NSURL.fileURLWithPath(path1!)
        self.kmlParser = KMLParser(URL: url)
        print(self.kmlParser.overlays)
        print(self.kmlParser.points)
        
        let path = NSBundle.mainBundle().pathForResource("TrailDataGeoJSON", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
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
    
    func updateCurrentTrail() {
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "Ok")
        errorAlert.show()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let newLocation = locations.last as! CLLocation
        //print("current position: \(newLocation.coordinate.longitude) , \(newLocation.coordinate.latitude)")
    }

}

