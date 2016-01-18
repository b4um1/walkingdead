//
//  GPSHandler.swift
//  TheWalkingDead
//
//  Created by User on 18/01/16.
//  Copyright © 2016 Mario Baumgartner. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

protocol ElevationDelegate {
    func updateElevation(elevation: Double)
}

class GPSHandler: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    
    var elevationDelegate: ElevationDelegate?
    
    var url = "https://maps.googleapis.com/maps/api/elevation/json?locations=39.7391536,-104.9847034&key=AIzaSyCkLFm7nxWU77VkkpY7Vx4VA-mDxq1hl0E"
    
    // https://maps.googleapis.com/maps/api/elevation/json?locations=39.7391536,-104.9847034&key=AIzaSyCkLFm7nxWU77VkkpY7Vx4VA-mDxq1hl0E
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations ...")
        
        let location = locations.last! as CLLocation
        
        let request = getUrl(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        
        Alamofire.request(.POST, request)
            .responseJSON { response in
                
                let json = JSON(response.result.value!)
                print(json)
                if json.isEmpty == false {
                    let elevation = json["results",0,"elevation"]
                    self.elevationDelegate?.updateElevation(elevation.doubleValue)
                    
                } else {
                    print("empty")
                }
        }
        
        /*
        let parameters = [
            "locations":"\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "key":"AIzaSyCkLFm7nxWU77VkkpY7Vx4VA-mDxq1hl0E"
        ]
        
        Alamofire.request(.POST, "https://maps.googleapis.com/maps/api/elevation/json", parameters: parameters)
            .responseJSON { response in
                print("response \(response)")
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print(json)
                    if json.isEmpty == false {
                        print(json)
                    } else {
                        print("empty")
                    }
                }
        }
*/
    }
    
    func getUrl(lat lat: Double, long: Double) -> String {
        return "https://maps.googleapis.com/maps/api/elevation/json?locations=\(lat),\(long)&key=AIzaSyCkLFm7nxWU77VkkpY7Vx4VA-mDxq1hl0E"
    }
}