//
//  PictureModel.swift
//  PlatDuJour
//
//  Created by GG on 06/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

struct PictureModel {
    var image: UIImage?
    var price: Double?
    var dishName: String?
    var restaurantName: String?
    var dishDescription: String?
    
    mutating func update(_ image: UIImage) {
        self.image = image
    }
    
    mutating func update(_ price: Double) {
        self.price = price
    }
    
    mutating func update(dishName name: String) {
        self.dishName = name
    }
    
    mutating func update(restaurantName name: String) {
        self.restaurantName = name
    }
    
    mutating func update(dishDescription description: String) {
        self.dishDescription = description
    }
}
