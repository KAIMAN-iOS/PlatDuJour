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

class ShareModel: NSObject {
    
    enum ModelType: Int, CaseIterable {
        case dailySpecial, event, basic
        
        var fields: [ShareModel.Field] {
            switch self {
            case .dailySpecial: return [.picture, .price, .dishName, .restaurantName, .description]
            case .event: return  [.asset, .eventName, .date, .description]
            case .basic: return  [.asset, .description]
            }
        }
        
        var displayName: String {
            switch self {
            case .dailySpecial: return "content daily special".local()
            case .event: return "content event".local()
            case .basic: return "content basic".local()
            }
        }
        
        var mediaTypes: [String] {
            switch self {
            case .dailySpecial: return ["public.image"]
            case .event: return ["public.image", "public.movie"]
            case .basic: return ["public.image", "public.movie"]
            }
        }
    }
    
    enum Field {
        case picture, asset, price, dishName, restaurantName, eventName, description, date
        
        var description: String {
            switch self {
            case .price: return "price".local()
            case .restaurantName: return "restaurantName".local()
            case .dishName: return "dishName".local()
            case .picture: return "picture".local()
            case .asset: return "asset".local()
            case .eventName: return "eventName".local()
            case .description: return "description".local()
            case .date: return "date".local()
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
                case .date: return "date placeholder".local()
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .price: return .decimalPad
            default: return .asciiCapable
            }
        }
    }
    
    var mediaURL: URL?  {
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

     var eventDate: Date = Date() {
        didSet {
            updateValidity()
        }
    }
    
    @objc dynamic var isValid: Bool = false
    
    func update(_ image: UIImage) {
        self.image = image
    }
    
    func update(_ mediaURL: URL) {
        self.mediaURL = mediaURL
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
    
    func update(_ date: Date) {
        self.eventDate = date
    }
    
    private var model: ModelType!
    init(model: ModelType) {
        self.model = model
        restaurantName = Defaults[\.restaurantName]
        price = Defaults[\.dishPrice]
        super.init()
    }
    
    private func updateValidity() {
        print("😘 fields \(model.fields)")
        isValid = model.fields.reduce(true, { (result, field) -> Bool in
            print("😘 isValid \(result) - field")
            switch field {
            case .picture: return result && image != nil
            case .asset: return result && mediaURL != nil
            case .price: return result && (price ?? 0 > 0)
            case .dishName: return result && dishName?.isEmpty == false
            case .restaurantName: return result && restaurantName?.isEmpty == false
            case .eventName: return result && eventName?.isEmpty == false
            case .description: return result && contentDescription?.isEmpty == false
            case .date: return result // date is never nil
            }
        })
    }
    
    func value(for field: Field) -> Any? {
        switch field {
        case .picture: return image
        case .asset: return mediaURL
        case .price: return price
        case .dishName: return dishName
        case .restaurantName: return restaurantName
        case .eventName: return eventName
        case .description: return contentDescription
        case .date: return eventDate
        }
    }
}
