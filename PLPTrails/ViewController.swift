//
//  ViewController.swift
//  PLPTrails
//
//  Created by Matthew Beatty on 12/30/15.
//  Copyright (c) 2015 Matthew Beatty. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fill in the next line with your style URL from Mapbox Studio
        let styleURL = NSURL(string: "mapbox://styles/beattymg/ciiug67uw00izzwmag6e6l10d")
        let mapView = MGLMapView(frame: view.bounds,
            styleURL: styleURL)
        mapView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        // set the map's center coordinate
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 41.1,
            longitude: -75.530),
            zoomLevel: 12, animated: false)
        view.addSubview(mapView)
    }
}

