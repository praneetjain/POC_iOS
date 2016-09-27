//
//  ViewController.swift
//  PizzaMe
//
//  Created by Praneet Jain on 5/25/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit
import CoreLocation

class MyLocationViewController: UITableViewController, CLLocationManagerDelegate{

    var shops = [Shop]()
    let locationManager = CLLocationManager()
    var location : CLLocation?
    var locationError : NSError?
    var updatingLocation = false
    let geocoder = CLGeocoder()
    var performGeocoding = false
    var geocodingError : NSError?
    var placemark : CLPlacemark?
    var zipCode = "78759"
    var selectedShop : Shop?
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        var cell = UINib(nibName: MyLocationIdentifiers.shopCell, bundle: nil)
        tableView.registerNib(cell, forCellReuseIdentifier: MyLocationIdentifiers.shopCell)
        tableView.rowHeight = 120
        
        cell = UINib(nibName: MyLocationIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cell, forCellReuseIdentifier: MyLocationIdentifiers.loadingCell)

        
        getUserLocation()
    }
    
    func fetchDataFromURLForPizzaShops(){
    
        isLoading = true
        
        var stringURL = "https://query.yahooapis.com/v1/public/yql?q=select * from local.search where zip%3D'78759' and query%3D'pizza'&format=json&diagnostics=true&callback="
        
        stringURL = stringURL.stringByReplacingOccurrencesOfString("78759", withString: zipCode)

        stringURL = stringURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        stringURL = stringURL.stringByReplacingOccurrencesOfString("'", withString: "%27")
        
        let url = NSURL(string: stringURL)!
        
        NSLog("%@", url)
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url) { data, response, error in
            

            if let data = data, dictionary = self.parseJSON(data){
            
            self.shops = self.parseDictionary(dictionary)
                
                dispatch_async(dispatch_get_main_queue()){
                
                self.isLoading = false
                self.tableView.reloadData()
                    
                }
                return
                
            }
            else{
            
                print("Data download failed: \(response)")
                
            }
            dispatch_async(dispatch_get_main_queue()){
            
                self.isLoading = false
                self.tableView.reloadData()
                self.showErrorMessage()
            
            }
            
        }
        dataTask.resume()
        
        
    
    }
    
    
    func parseJSON(data : NSData) -> [String : AnyObject]?{
    
        do{
        
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject]
        }
        catch{
        print("parseJSON failed with error: \(error)")
            return nil
        }
    
    }
    
    func parseDictionary(dictionary : [String : AnyObject]) -> [Shop]{
    
        guard let dictQuery = dictionary["query"] as? [String : AnyObject] else{
        
        print("parse query dictionary failed")
            return []
        }
    
        guard let dictResults = dictQuery["results"] as? [String : AnyObject] else{
        
            print("parseResults dictionary failed")
            return []
        }
        
        guard let array = dictResults["Result"] as? [AnyObject] else{
        
            print("parseArray failed")
            return []
        }
    
        var shops = [Shop]()
        
        for shopDict in array {
            
            if let shopDict = shopDict as? [String : AnyObject]{
            
                let shop = Shop()
                
                if let title = shopDict["Title"] as? String{
                    shop.name = title
                }
                if let address = shopDict["Address"] as? String{
                    shop.address = address
                }
                if let city = shopDict["City"] as? String{
                    shop.city = city
                }
                if let state = shopDict["State"] as? String{
                    shop.state = state
                }
                if let phone = shopDict["Phone"] as? String{
                    shop.phone = phone
                }
                if let distance = shopDict["Distance"] as? String{
                    shop.distance = distance
                }
                shops.append(shop)
            }
            
        }
        
    return shops
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getUserLocation(){
    
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted{
        showLoctionServicesAccessRequestDeniedAlert()
            return
        }
        
       startLocationManger()
    
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Failed to update location with error: \(error)")
        
        if error.code == CLError.LocationUnknown.rawValue{
        
            return
        }
        
        locationError = nil
        locationError = error
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        print("didUpdateLocations: \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5{
            return
        }
        if newLocation.horizontalAccuracy < 0{
            return
        }
        if location == nil || location!.horizontalAccuracy >  newLocation.horizontalAccuracy{
            locationError = nil
            location = newLocation
        }
        
        if !performGeocoding{
        
        performGeocoding = true
            
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { placemarks, error in
            
            if let error = error{
            
            print("Reverse geocoding failed with error: \(error)")
            return
            }
            
            print("*** Found placemarks: \(placemarks)")
            
            self.geocodingError = error
            
            if error == nil, let p = placemarks where !p.isEmpty{
            
              self.placemark = p.last!
                if let zip = self.placemark?.postalCode{
                    self.zipCode = zip
                    self.fetchDataFromURLForPizzaShops()
                    dispatch_async(dispatch_get_main_queue()){
                    
                    self.tableView.reloadData()
                    }
                }
            
            }
            else{
              self.placemark = nil
            }
        })
            
        
        }
        
    }
    
    func showLoctionServicesAccessRequestDeniedAlert(){
    
        let alert = UIAlertController(title: "Location Service Disabled", message: "Please enable Location Services in Settings.", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    func startLocationManger(){
    
        if !updatingLocation && CLLocationManager.locationServicesEnabled(){
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    
    
    }
    
    func stopLocationManager(){
    
        if updatingLocation{
        
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        
        }
        
        
    }

    func showErrorMessage(){
    
    let alert = UIAlertController(title: "Error", message: "Fetching value from server failed. Please try again.", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    struct MyLocationIdentifiers{
    
    static let loadingCell = "LoadingCell"
    static let shopCell = "ShopCell"
    static let segueDetailScreen = "ItemDetail"
        
    }
    
    deinit{
    
        stopLocationManager()
        performGeocoding = false
        updatingLocation = false
        isLoading = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == MyLocationIdentifiers.segueDetailScreen{
        
        let controller = segue.destinationViewController as! DetailViewController
        controller.shop = selectedShop
            
        }
    }
}


//MARK: - TableViewDataSource
extension MyLocationViewController{

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading{
        
            return 1
        }
        
        return shops.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isLoading {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(MyLocationIdentifiers.loadingCell, forIndexPath: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MyLocationIdentifiers.shopCell, forIndexPath: indexPath) as! ShopCell
        
        if !shops.isEmpty{
        
            let shop = shops[indexPath.row]
            cell.configureForShop(shop)
        }
         return cell
}
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedShop = shops[indexPath.row]
                
        performSegueWithIdentifier(MyLocationIdentifiers.segueDetailScreen, sender: indexPath)
        
    }
    
    //This function is getting called when the application opens. We are starting our locationManager
    //inside this.
    func applicationLaunched(){
        getUserLocation()
        fetchDataFromURLForPizzaShops()

    }
    
}