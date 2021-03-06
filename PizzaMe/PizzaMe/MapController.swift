//
//  MapController.swift
//  PizzaMe
//
//  Created by Praneet Jain on 5/27/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapController : UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    var shopLocation : String?
    var shopName : String?
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUser()
        showShopLocation()

}
    func showUser(){
    
        mapView.showsUserLocation = true

    }
    
    func showShopLocation(){
    
        geocoder.geocodeAddressString(shopLocation!) { placemaks, error in
            
            if let placemaks = placemaks{
                let latShop = placemaks.last!.location?.coordinate.latitude
                let longShop = placemaks.last!.location?.coordinate.longitude
                let shopLocationCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latShop!, longitude: longShop!)
                
                let shopAnnotation = MKPointAnnotation()
                
                shopAnnotation.coordinate = shopLocationCoordinate
                
                shopAnnotation.title = self.shopName
                self.mapView.addAnnotation(shopAnnotation)

            }
            else{
            
                self.showNetworkError()
            }
            
            
            
        }
    }

    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func showNetworkError(){
    
    let alert = UIAlertController(title: "Whoops...", message: "Unable to get location. Please check your internet connection or try again after some time.", preferredStyle: .alert)
        
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
    extension MapController:UINavigationBarDelegate{
        
        func position(for bar : UIBarPositioning) -> UIBarPosition{
            return .topAttached
        }
        
}

extension MapController : MKMapViewDelegate{



}
