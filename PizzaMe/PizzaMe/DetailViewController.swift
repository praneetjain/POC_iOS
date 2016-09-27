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
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
    }
    @IBAction func callPhoneTapped(_ sender : UIButton){
    
    var stringNumber = sender.titleLabel?.text?.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
        
    stringNumber = "tel://"+stringNumber!
    let url = URL(string: stringNumber!)
        
    UIApplication.shared.openURL(url!)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as! MapController
        controller.shopLocation = shop?.address
        controller.shopName = shop?.name
        
    }
    
    func setLabelValues(){
    
        labelShopName.text = shop!.name
        labelShopAddress.text = shop!.address
        labelShopState.text = shop!.state
        labelShopCity.text = shop!.city
        labelShopDistance.text = "\(shop!.distance) mi"
        buttonShopPhone.setTitle("Call: \(shop!.phone)", for: UIControlState())
        
    }


}
