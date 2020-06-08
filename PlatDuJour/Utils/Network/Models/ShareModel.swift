//
//  PictureModel.swift
//  PlatDuJour
//
//  Created by GG on 06/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Photos

extension DefaultsKeys {
    var restaurantName: DefaultsKey<String?> { .init("restaurantName") }
    var dishPrice: DefaultsKey<Double?> { .init("dishPrice") }
}

class ShareModel: NSObject {
    
    enum ModelType {
        case dailySpecial, event
        
        var fields: [ShareModel.Field] {
            switch self {
            case .dailySpecial: return [.picture, .price, .dishName, .restaurantName, .description]
            case .event: return  [.asset, .eventName, .description]
            }
        }
    }
    
    enum Field {
        case picture, asset, price, dishName, restaurantName, eventName, description
        
        var description: String {
            switch self {
            case .price: return "price".local()
            case .restaurantName: return "restaurantName".local()
            case .dishName: return "dishName".local()
            case .picture: return "picture".local()
            case .asset: return "asset".local()
            case .eventName: return "eventName".local()
            case .description: return "description".local()
            }
        }
        
        var placeholder: String {
            switch self {
                case .price: return "price placeholder".local()
                case .restaurantName: return "restaurantName placeholder".local()
                case .dishName: return "dishName placeholder".local()
                case .picture: return "picture placeholder".local()
                case .asset: return "asset placeholder".local()
                case .eventName: return "eventName placeholder".local()
                case .description: return "description placeholder".local()
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .price: return .decimalPad
            default: return .asciiCapable
            }
        }
    }
    
    var asset: PHAsset?  {
        didSet {
            updateValidity()
        }
    }

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
     var eventName: String?  {
         didSet {
            updateValidity()
          }
      }
    var contentDescription: String? {
       didSet {
           updateValidity()
       }
   }
    @objc dynamic var isValid: Bool = false
    
    func update(_ image: UIImage) {
        self.image = image
    }
    
    func update(_ asset: PHAsset) {
        self.asset = asset
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
    
    func update(eventName name: String) {
        self.eventName = name
    }
    
    func update(dishDescription description: String) {
        self.contentDescription = description
    }
    
    private var model: ModelType!
    init(model: ModelType) {
        self.model = model
        restaurantName = Defaults[\.restaurantName]
        price = Defaults[\.dishPrice]
        super.init()
    }
    
    private func updateValidity() {
        isValid = model.fields.reduce(false, { (result, field) -> Bool in
            switch field {
            case .picture: return result && image != nil
            case .asset: return result && asset != nil
            case .price: return result && (price ?? 0 > 0)
            case .dishName: return result && dishName?.isEmpty == false
            case .restaurantName: return result && restaurantName?.isEmpty == false
            case .eventName: return result && eventName?.isEmpty == false
            case .description: return result && contentDescription?.isEmpty == false
            }
        })
    }
    
    func value(for field: Field) -> Any? {
        switch field {
        case .picture: return image
        case .asset: return asset
        case .price: return price
        case .dishName: return dishName
        case .restaurantName: return restaurantName
        case .eventName: return eventName
        case .description: return contentDescription
        }
    }
}
