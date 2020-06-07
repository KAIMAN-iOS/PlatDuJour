//
//  PictureModel.swift
//  PlatDuJour
//
//  Created by GG on 06/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    var restaurantName: DefaultsKey<String?> { .init("restaurantName") }
    var dishPrice: DefaultsKey<Double?> { .init("dishPrice") }
}

class PictureModel: NSObject {
    var image: UIImage?  {
        didSet {
            updateValidity()
        }
    }
    var price: Double?  {
        didSet {
            Defaults[\.dishPrice] = price
            updateValidity()
        }
    }
    var dishName: String? {
        didSet {
            updateValidity()
        }
    }
    var restaurantName: String?  {
        didSet {
           Defaults[\.restaurantName] = restaurantName
           updateValidity()
         }
     }
    var dishDescription: String? {
       didSet {
           updateValidity()
       }
   }
    @objc dynamic var isValid: Bool = false
    
    func update(_ image: UIImage) {
        self.image = image
    }
    
    func update(_ price: Double) {
        self.price = price
    }
    
    func update(dishName name: String) {
        self.dishName = name
    }
    
    func update(restaurantName name: String) {
        self.restaurantName = name
    }
    
    func update(dishDescription description: String) {
        self.dishDescription = description
    }
    
    override init() {
        restaurantName = Defaults[\.restaurantName]
        price = Defaults[\.dishPrice]
        super.init()
    }
    
    private func updateValidity() {
        isValid = image != nil && (price ?? 0 > 0) && dishName?.isEmpty == false && restaurantName?.isEmpty == false && dishDescription?.isEmpty == false
    }
}
