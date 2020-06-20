
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
import SwiftyUserDefaults


class ShareAccountManager: NSObject {
    private var facebookSwitchObservation: NSKeyValueObservation?
    private var instagramSwitchObservation: NSKeyValueObservation?
    private var twitterSwitchObservation: NSKeyValueObservation?
    @objc dynamic var atLeastOneServiceIsActivated: Bool = false
    
    static let shared: ShareAccountManager = ShareAccountManager()
    
    private override init() {
        super.init()
        // observe the UserDefaults for the switches states and update the atLeastOneServiceIsActivated accordingly
        facebookSwitchObservation = UserDefaults.standard.observe(\.facebookSwitchOn,
                              options: [.old, .new]
        ) { [weak self] _, change in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.atLeastOneServiceIsActivated = AccountType.atLeastOneServiceIsActivated
            }
        }
        
        instagramSwitchObservation = UserDefaults.standard.observe(\.instagramSwitchOn,
                              options: [.old, .new]
        ) { [weak self] _, change in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.atLeastOneServiceIsActivated = AccountType.atLeastOneServiceIsActivated
            }
        }
        
        twitterSwitchObservation = UserDefaults.standard.observe(\.twitterSwitchOn,
                              options: [.old, .new]
        ) { [weak self] _, change in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.atLeastOneServiceIsActivated = AccountType.atLeastOneServiceIsActivated
            }
        }
    }
    
    enum AccountType: Int, CaseIterable {
        case facebook, instagram, twitter
        
        static var atLeastOneServiceIsActivated: Bool {
            print("🏂 \(AccountType.allCases.compactMap({ $0.switchState }))")
            return AccountType.allCases.reduce(false, { $0 || $1.switchState })
        }
        
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
        
        var isEnabled: Bool {
            switch self {
            case .facebook: return true
            case .instagram: return true
            default: return false
            }
        }
        
        func toggleSwitch() {
            switch self {
            case .facebook: Defaults[\.facebookSwitchOn].toggle()
            case .instagram: Defaults[\.instagramSwitchOn].toggle()
            case .twitter: Defaults[\.twitterSwitchOn].toggle()
            }
        }
        
        var switchState: Bool {
            switch self {
            case .facebook: return Defaults[\.facebookSwitchOn]
            case .instagram: return Defaults[\.instagramSwitchOn]
            case .twitter: return Defaults[\.twitterSwitchOn]
            }
        }
    }
    
    enum AccountStatus {
        case logged, notLogged
        
        func text(for accountType: AccountType, hasSwitch: Bool = false) -> String {
            var text: String = ""//accountType.displayName + " - "
            
            switch self {
            case .logged: text += "logged".local() /*+ "(\(ShareAccountManager.shared.accountName(for: accountType) ?? ""))" */ + (hasSwitch ? "" : "tap to disconnect".local())
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
            case .facebook: completion((AccessToken.current?.hasGranted(permission: "pages_manage_posts") ?? false) ? .logged : .notLogged)
            case .instagram: completion((AccessToken.current?.hasGranted(permission: "instagram_basic") ?? false) ? .logged : .notLogged)
        default: completion(.notLogged)
        }
    }
    
    func logOut(for accountType: AccountType, completion: @escaping ((Bool) -> Void)) {
        switch accountType {
        case .facebook:
            GraphRequest.init(graphPath: "me/permissions/pages_manage_posts", httpMethod: .delete).start { (connexion, result, error) in
                let success = Int((result as? [String:Any])?["success"] as? Int ?? 0) == 1
                if success {
                    AccessToken.refreshCurrentAccessToken {(connexion, result, error) in
                        completion(AccessToken.current?.hasGranted(permission: "pages_manage_posts") ?? false)
                    }
                } else {
                    completion(false)
                }
            }
            
        case .instagram:
            GraphRequest.init(graphPath: "me/permissions/instagram_basic", httpMethod: .delete).start { (connexion, result, error) in
                let success = Int((result as? [String:Any])?["success"] as? Int ?? 0) == 1
                if success {
                    AccessToken.refreshCurrentAccessToken {(connexion, result, error) in
                        completion(AccessToken.current?.hasGranted(permission: "instagram_basic") ?? false)
                    }
                } else {
                    completion(false)
                }
            }
            
        default: completion(true)
        }
    }
    
    func askPermission(for accountType: AccountType, from controller: UIViewController, completion: @escaping ((Bool) -> Void)) {
        switch accountType {
        case .facebook:
            // pages_manage_posts, pages_read_engagement
            if AccessToken.current?.hasGranted(permission: "pages_manage_posts") == true {
                completion(true)
            } else {
                LoginManager().logIn(permissions: ["pages_manage_posts"/*, "pages_manage_metadata", "pages_manage_read_engagement"*/], viewController: controller) { result in
                    print("res \(result)")
                    switch result {
                    case .success:
                        // the pageId is in data>id
                        Defaults[\.facebookSwitchOn] = true
                        GraphRequest.init(graphPath: "me/accounts").start { (connexion, result, error) in
                            guard let result = result as? [String:Any],
                                  let dataArray = result["data"] as? Array<Any>,
                                  let data = dataArray.first as? [String:Any],
                                  let pageId = data["id"] as? String else { return }
                            print("\(pageId)")
                        }
                        completion(true)

                    case .failed(let error):
                        completion(false)
                        MessageManager.show(.basic(.custom(title: "Oups".local(), message: error.localizedDescription, buttonTitle: nil, configuration: MessageDisplayConfiguration.alert)), in: controller)

                    default: ()
                    }
                }
            }
            
        case .instagram: // instagram_content_publish
            if AccessToken.current?.hasGranted(permission: "instagram_basic") == true {
                completion(true)
            } else {
                LoginManager().logIn(permissions: ["instagram_basic"/*, "instagram_content_publish", "publish_video", "manage_pages", "publish_pages"*/], viewController: controller) { result in
                    print("res \(result)")
                    switch result {
                    case .success:
                        Defaults[\.instagramSwitchOn] = true
                        // the pageId is in data>id
                        GraphRequest.init(graphPath: "me/accounts").start { (connexion, result, error) in
                            guard let result = result as? [String:Any],
                                  let dataArray = result["data"] as? Array<Any>,
                                  let data = dataArray.first as? [String:Any],
                                  let pageId = data["id"] as? String else { return }
                            print("\(pageId)")
                            Defaults[\.facebookPageId] = pageId
                        }
                        completion(true)

                    case .failed(let error):
                        completion(false)
                        MessageManager.show(.basic(.custom(title: "Oups".local(), message: error.localizedDescription, buttonTitle: nil, configuration: MessageDisplayConfiguration.alert)), in: controller)

                    default: ()
                    }
                }
            }
            
        case .twitter:
            ()
        }
    }
}

extension UIViewController {
    static func mainController() -> UIViewController?  {
        return ((UIApplication.shared.delegate) as? AppDelegate)?.appCoordinator.mainController
    }
}

extension ShareAccountManager: AccountStateDelegate {
    func stateChanged(for account: AccountType) {
        account.toggleSwitch()
    }
}
