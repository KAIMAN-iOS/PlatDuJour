//
//  Onboarding.swift
//  CovidApp
//
//  Created by jerome on 28/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import UIKit

enum Onboarding: Int, CaseIterable {
    case welcome = 0
    case purpose
    case addSocialNetwork
    case takePicture
    case chooseFromTemplate
    case letsGo
    
    var title: String {
        switch self {
        case .welcome: return "Onboarding welcome title".local()
        case .purpose: return "Onboarding purpose title".local()
        case .addSocialNetwork: return "Onboarding addSocialNetwork title".local()
        case .takePicture: return "Onboarding takePicture title".local()
        case .chooseFromTemplate: return "Onboarding chooseFromTemplate title".local()
        case .letsGo: return ""
        }
    }
    
    var subtitle: String {
        switch self {
        case .welcome: return "Onboarding welcome subtitle".local()
        case .purpose: return "Onboarding purpose subtitle".local()
        case .addSocialNetwork: return "Onboarding addSocialNetwork subtitle".local()
        case .takePicture: return "Onboarding takePicture subtitle".local()
        case .chooseFromTemplate: return "Onboarding chooseFromTemplate subtitle".local()
        case .letsGo: return ""
        }
    }
    
    var image: UIImage! {
        switch self {
        case .welcome: return UIImage(named: "welcome")!
        case .purpose: return UIImage(named: "purpose")!
        case .addSocialNetwork: return UIImage(named: "addSocialNetwork")!
        case .takePicture: return UIImage(named: "takePicture")!
        case .chooseFromTemplate: return UIImage(named: "chooseFromTemplate")!
        case .letsGo: return UIImage(named: "letsGo")!
        }
    }
}
