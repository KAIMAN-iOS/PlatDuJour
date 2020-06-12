
//
//  ShareAccountManager.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
import FacebookShare
import FacebookLogin
import FacebookCore
import SwiftyInsta
import Swifter

class ShareAccountManager {
    private init() {}
    static let shared: ShareAccountManager = ShareAccountManager()
    
    enum AccountType: Int, CaseIterable {
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
            var text: String = ""//accountType.displayName + " - "
            
            switch self {
            case .logged: text += "logged".local() + "(\(ShareAccountManager.shared.accountName(for: accountType) ?? ""))" + (hasSwitch ? "" : "tap to disconnect".local())
            case .notLogged: text += "notLogged".local() + (hasSwitch ? "" : "tap to connect".local())
            }
            return text
        }
    }
    
    func accountName(for accountType: AccountType) -> String? {
        switch accountType {
        case .facebook: return AccessToken.current?.userID
        default: return nil
        }
    }
    
    func status(for accountType: AccountType, completion: @escaping ((AccountStatus) -> Void)) {
        switch accountType {
        case .facebook: completion(AccessToken.current != nil ? .logged : .notLogged)
        default: completion(.notLogged)
        }
    }
    
    func askPermission(for accountType: AccountType, completion: @escaping ((Bool) -> Void)) {
        switch accountType {
        case .facebook:
            LoginManager().logOut()
            
            // pages_manage_posts, pages_read_engagement
            if AccessToken.current?.hasGranted(Permission.email) == true {
                completion(true)
            } else {
                LoginManager().logIn(permissions: [.email, .publicProfile, .userBirthday], viewController: UIViewController.mainController()!) { result in
                    print("res \(result)")
                    switch result {
                    case .success:
                        GraphRequest.init(graphPath: "me/feed", parameters: ["message" : "this is a test"], httpMethod: .post).start { [weak self] (connection, result, error) in
                            guard let self = self else { return }
                            
                        }
                        completion(true)

                    case .failed(let error):
                        completion(false)
                        MessageManager.show(.basic(.custom(title: "Oups".local(), message: error.localizedDescription, buttonTitle: nil, configuration: MessageDisplayConfiguration.alert)), in: UIViewController.mainController()!)

                    default: ()
                    }
                }
            }
            
        case .instagram:
            ()
            
        case .twitter:
            ()
        }
    }
}

private extension UIViewController {
    static func mainController() -> UIViewController?  {
        return ((UIApplication.shared.delegate) as? AppDelegate)?.appCoordinator.mainController
    }
}

