
//
//  ShareAccountManager.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
import FacebookShare
import SwiftyInsta
import Swifter

class ShareAccountManager {
    private init() {}
    static let shared: ShareAccountManager = ShareAccountManager()
    
    enum AccountType {
        case facebook, instagram, twitter
        
        var icon: UIImage? {
            switch self {
            case .facebook: return UIImage(named: "facebook")
            case .instagram: return UIImage(named: "instagram")
            case .twitter: return UIImage(named: "twitter")
            }
        }
        
        var displayName: String {
            switch self {
            case .facebook: return "Facebook"
            case .instagram: return "Instagram"
            case .twitter: return "Twitter"
            }
        }
        
        func text(for status: AccountStatus, hasSwitch: Bool = false) -> String {
            return status.text(for: self, hasSwitch: hasSwitch)
        }
    }
    
    enum AccountStatus {
        case logged, notLogged
        
        func text(for accountType: AccountType, hasSwitch: Bool = false) -> String {
            var text: String = accountType.displayName + " - "
            
            switch self {
            case .logged: text += "logged".local() + (hasSwitch ? "" : "tap to disconnect".local())
            case .notLogged: text += "notLogged".local() + (hasSwitch ? "" : "tap to connect".local())
            }
            return text
        }
    }
    
    fileprivate func status(for accountType: AccountType, completion: @escaping ((AccountStatus) -> Void)) {
        completion(.notLogged)
    }
}
