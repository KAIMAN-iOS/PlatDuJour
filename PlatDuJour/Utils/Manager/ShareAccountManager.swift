
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
    
    enum AccountType: Int, CaseIterable, Codable {
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
                LoginManager().logIn(permissions: ["pages_manage_posts", "pages_read_engagement", "pages_show_list"], viewController: controller) { result in
                    print("res \(result)")
                    switch result {
                    case .success:
                        // the pageId is in data>id
                        Defaults[\.facebookSwitchOn] = true
                        GraphRequest.init(graphPath: "me/accounts").start { (connexion, result, error) in
                            guard let result = result as? [String:Any],
                                  let dataArray = result["data"] as? Array<Any>,
                                  let data = dataArray.first as? [String:Any],
                                  let pageId = data["id"] as? String,
                                  let access = data["access_token"] as? String else { return }
                            print("\(pageId)")
                            Defaults[\.facebookPageId] = pageId
                            Defaults[\.facebookPageAccessToken] = access
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
                LoginManager().logIn(permissions: ["instagram_basic", "instagram_content_publish"], viewController: controller) { result in
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
    
    
    /**
     publish the model to the AccountTypes where the switchState is On
     
     - parameters:
         - model : the model to publish. The function will update the model with all the publication URL for each accountType that succeeded
         - completion : the completion block to inform if the publication went well or not
     */
    func publish(model: inout ShareModel, completion: @escaping (([AccountType:Result<Bool>]) -> Void)) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "publishQueue", qos: .default)
        var publishStates: [AccountType:Result<Bool>] = [:]
        
        AccountType.allCases.filter({ $0.switchState == true }).forEach { [weak self] accountType in
            guard let self = self else { return }
            group.enter()
            self.publish(model: &model, on: accountType, in: group) { success in
                publishStates[accountType] = success
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            completion(publishStates)
        }
    }
    
    enum AccountError: Error {
        case notImplementedYet
        case notConnected
        case noMediaToUpload
    }
    
    private func requetsPageToken(completion: @escaping ((String?) -> Void)) {
        GraphRequest.init(graphPath: "me/accounts", parameters: ["access_token" : AccessToken.current!.tokenString]).start { (connexion, result, error) in
            guard let result = result as? [String:Any],
            let dataArray = result["data"] as? Array<Any>,
            let data = dataArray.first as? [String:Any],
            let access = data["access_token"] as? String  else {
                completion(nil)
                return
            }
            completion(access)
        }
    }
    
    private func publish(model: inout ShareModel, on accountType: AccountType, in group: DispatchGroup, completion: @escaping ((Result<Bool>) -> Void)) {
        switch accountType {
        case .facebook:
            guard let pageId = Defaults[\.facebookPageId],
                let token = Defaults[\.facebookPageAccessToken],
                let tokenData = token.data(using: .utf8) else {
                completion(Result.failure(AccountError.notConnected))
                return
            }
            guard let data = try? model.image?.heicData(), let contentDescription = model.contentDescription, let contentData = contentDescription.data(using: .utf8) else {
                completion(Result.failure(AccountError.noMediaToUpload))
                return
            }
            
            self.requetsPageToken { token in
                guard let token = token else { return }
//
//                let image =  GraphRequestDataAttachment(data: data, filename: "source", contentType: "image/heic")
//                let text = GraphRequestDataAttachment(data: contentData, filename: "caption", contentType: "text")
//                let accessToken = GraphRequestDataAttachment(data: tokenData, filename: "access_token", contentType: "text")
//                GraphRequest
//                    .init(graphPath: "\(pageId)/photos",
//                    parameters: ["source" : image, "caption" : text, "access_token" : token, "published" : false],
//                        httpMethod: .post)
//                    .start { (connexion, result, error) in
//                    completion(Result.success(true))
//                }
                
                // test
                GraphRequest
                    .init(graphPath: "\(pageId)/photos",
                        parameters: ["caption" : contentDescription, "url" : "https://www.cdiscount.com/pdt2/9/2/8/1/700x700/889698377928/rw/figurine-funko-pop-deluxe-game-of-thrones-daen.jpg", "access_token" : token],
                        httpMethod: .post)
                    .start { (connexion, result, error) in
                    completion(Result.success(true))
                }
            }
            completion(Result.success(true))
            
        default: completion(Result.failure(AccountError.notImplementedYet))
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
