//
//  DetailViewController.swift
//  PizzaMe
//
//  Created by Praneet Jain on 5/26/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController{

    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopAddress: UILabel!
    
    @IBOutlet weak var buttonShopPhone: UIButton!
    @IBOutlet weak var labelShopCity: UILabel!
    
    @IBOutlet weak var labelShopDistance: UILabel!
    @IBOutlet weak var labelShopState: UILabel!
    var shop : Shop?

    override func viewDidLoad() {
    super.viewDidLoad()
        setLabelValues()
    
    }
    
    @IBAction func mapButtonTapped(sender: UIButton) {
    }
    @IBAction func callPhoneTapped(sender : UIButton){
    
    var stringNumber = sender.titleLabel?.text?.stringByReplacingOccurrencesOfString("\\D", withString: "", options: .RegularExpressionSearch, range: nil)
        
    stringNumber = "tel://"+stringNumber!
    let url = NSURL(string: stringNumber!)
        
    UIApplication.sharedApplication().openURL(url!)
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! MapController
        controller.shopLocation = shop?.address
        controller.shopName = shop?.name
        
    }
    
    func setLabelValues(){
    
        labelShopName.text = shop!.name
        labelShopAddress.text = shop!.address
        labelShopState.text = shop!.state
        labelShopCity.text = shop!.city
        labelShopDistance.text = "\(shop!.distance) mi"
        buttonShopPhone.setTitle("Call: \(shop!.phone)", forState: .Normal)
        
    }


}