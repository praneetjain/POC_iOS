//
//  ShopCell.swift
//  PizzaMe
//
//  Created by Praneet Jain on 5/26/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import Foundation
import UIKit

class ShopCell : UITableViewCell{

    @IBOutlet weak var labelShopName: UILabel!

    @IBOutlet weak var labelShopAddress: UILabel!

    @IBOutlet weak var labelShopPhone: UILabel!
    @IBOutlet weak var labelShopCity: UILabel!

    @IBOutlet weak var labelShopDistance: UILabel!
    @IBOutlet weak var labelShopState: UILabel!
    
    func configureForShop(shop : Shop){
    
    labelShopName.text = shop.name
    labelShopAddress.text = shop.address
    labelShopCity.text = shop.city
    labelShopPhone.text = shop.phone
    labelShopDistance.text = "\(shop.distance) mi"
    labelShopState.text = shop.state
    }
    
    
    
    
}