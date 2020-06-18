//
//  Configuration.swift
//  CovidApp
//
//  Created by jerome on 26/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import UIKit
import Foundation
import SwiftyUserDefaults

protocol Fontable {
    var font: UIFont { get }
}

enum FontType {
    case bigTitle
    case title
    case button
    case subTitle
    case `default`
    case footnote
    case custom(_: Font.TextStyle, traits:[UIFontDescriptor.SymbolicTraits]?)
}

struct Constants {
    
    enum ComponentShape {
        case capsule
        case rounded(value: CGFloat)
        case square
        
        func applyShape(on view: UIView) {
            switch self {
            case .capsule:
                view.layer.cornerRadius = view.bounds.height / 2
            case .rounded(let value):
                view.layer.cornerRadius = value
            case .square:
                view.layer.cornerRadius = 0
            }
        }
    }
    static var defaultComponentShape: Constants.ComponentShape { return .capsule }
    static var skipLogin: Bool = false
    
    #if DEBUG
    static var resetAtStart: Bool = false
    #else
    // ⚠️ do not change this value for release purposes! 
    static var resetAtStart: Bool = false
    #endif
}

extension FontType: Fontable {
    var font: UIFont {
        switch self {
        case .bigTitle:
            return Font.style(.title2).bold()
        case .title:
            return Font.style(.headline).bold()
        case .button:
            return Font.style(.subheadline).bold()
        case .subTitle:
            return Font.style(.callout).bold()
        case .default:
            return Font.style(.callout)
        case .footnote:
            return Font.style(.footnote)
        case .custom(let style, let traits):
            return Font.style(style).withTraits(traits: traits ?? [])
        }
    }
}

extension DefaultsKeys {
    // facebook specific
    var facebookPageId: DefaultsKey<String?> { .init("facebookPageId") }
    // social networks
    var facebookSwitchOn: DefaultsKey<Bool> { .init("onboardingWasShown", defaultValue: false) }
    var instagramSwitchOn: DefaultsKey<Bool> { .init("onboardingWasShown", defaultValue: false) }
    var twitterSwitchOn: DefaultsKey<Bool> { .init("onboardingWasShown", defaultValue: false) }
    // warnings
    var videoPlayerTouchWarningWasShown: DefaultsKey<Bool> { .init("videoPlayerTouchWarningWasShown", defaultValue: false) }
    // init
    var username: DefaultsKey<String?> { .init("username") }
    var onboardingWasShown: DefaultsKey<Bool> { .init("onboardingWasShown", defaultValue: false) }
    var initialValuesFilled: DefaultsKey<Bool> { .init("initialValuesFilled", defaultValue: false) }
    var alreadyRequestedNotifications: DefaultsKey<Bool> { .init("alreadyRequestedNotifications", defaultValue: false) }
    var notificationsEnabled: DefaultsKey<Bool> { .init("notificationsEnabled", defaultValue: false) }
    var collectedFirstData: DefaultsKey<Bool> { .init("collectedFirstData", defaultValue: false) }
    var hourForNotification: DefaultsKey<Date?> { .init("hourForNotification", defaultValue: nil) }
    var dailyNotificationId: DefaultsKey<String?> { .init("dailyNotificationId", defaultValue: nil) }
    var loginOrigin: DefaultsKey<Int?> { .init("LoginOrigin", defaultValue: nil) }
    // model
    var restaurantName: DefaultsKey<String?> { .init("restaurantName") }
    var dishPrice: DefaultsKey<Double?> { .init("dishPrice") }
    
    
//    func clearUserDefaults() {
//        Defaults[\.facebookPageId] = nil
//    }
}
