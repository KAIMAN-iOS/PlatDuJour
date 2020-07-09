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
    static let resetAtStart: Bool = false
    #else
    // ⚠️⚠️⚠️
    // do not change this value for release purposes!
    static let resetAtStart: Bool = false
    // ⚠️⚠️⚠️
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

private enum Keys: String {
    case facebookPageId = "facebookPageId"
    case facebookPageAccessToken = "facebookPageAccessToken"
    case networks = "networks"
    case facebookSwitchOn = "facebookSwitchOn"
    case instagramSwitchOn = "instagramSwitchOn"
    case twitterSwitchOn = "twitterSwitchOn"
    case videoPlayerTouchWarningWasShown = "videoPlayerTouchWarningWasShown"
    case username = "username"
    case onboardingWasShown = "onboardingWasShown"
    case initialValuesFilled = "initialValuesFilled"
    case alreadyRequestedNotifications = "alreadyRequestedNotifications"
    case notificationsEnabled = "notificationsEnabled"
    case collectedFirstData = "collectedFirstData"
    case hourForNotification = "hourForNotification"
    case dailyNotificationId = "dailyNotificationId"
    case loginOrigin = "loginOrigin"
    case restaurantName = "restaurantName"
    case dishPrice = "dishPrice"
}

extension DefaultsKeys {
    var facebookPageId: DefaultsKey<String?> { .init(Keys.facebookPageId.rawValue) }
    var facebookPageAccessToken: DefaultsKey<String?> { .init(Keys.facebookPageAccessToken.rawValue) }
    var facebookSwitchOn: DefaultsKey<Bool> { .init(Keys.facebookSwitchOn.rawValue, defaultValue: false) }
    var instagramSwitchOn: DefaultsKey<Bool> { .init(Keys.instagramSwitchOn.rawValue, defaultValue: false) }
    var twitterSwitchOn: DefaultsKey<Bool> { .init(Keys.twitterSwitchOn.rawValue, defaultValue: false) }
    var videoPlayerTouchWarningWasShown: DefaultsKey<Bool> { .init(Keys.videoPlayerTouchWarningWasShown.rawValue, defaultValue: false) }
    var username: DefaultsKey<String?> { .init(Keys.username.rawValue) }
    var onboardingWasShown: DefaultsKey<Bool> { .init(Keys.onboardingWasShown.rawValue, defaultValue: false) }
    var initialValuesFilled: DefaultsKey<Bool> { .init(Keys.initialValuesFilled.rawValue, defaultValue: false) }
    var alreadyRequestedNotifications: DefaultsKey<Bool> { .init(Keys.alreadyRequestedNotifications.rawValue, defaultValue: false) }
    var notificationsEnabled: DefaultsKey<Bool> { .init(Keys.notificationsEnabled.rawValue, defaultValue: false) }
    var collectedFirstData: DefaultsKey<Bool> { .init(Keys.collectedFirstData.rawValue, defaultValue: false) }
    var hourForNotification: DefaultsKey<Date?> { .init(Keys.hourForNotification.rawValue, defaultValue: nil) }
    var dailyNotificationId: DefaultsKey<String?> { .init(Keys.dailyNotificationId.rawValue, defaultValue: nil) }
    var loginOrigin: DefaultsKey<Int?> { .init(Keys.loginOrigin.rawValue, defaultValue: nil) }
    var restaurantName: DefaultsKey<String?> { .init(Keys.restaurantName.rawValue) }
    var dishPrice: DefaultsKey<Double?> { .init(Keys.dishPrice.rawValue) }
}

// for KVO purposes
extension UserDefaults {
    @objc dynamic var facebookSwitchOn: Bool {
        return bool(forKey: Keys.facebookSwitchOn.rawValue)
    }
    @objc dynamic var instagramSwitchOn: Bool {
        return bool(forKey: Keys.instagramSwitchOn.rawValue)
    }
    @objc dynamic var twitterSwitchOn: Bool {
        return bool(forKey: Keys.twitterSwitchOn.rawValue)
    }
}
