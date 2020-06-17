//
//  AppCoordinator.swift
//  CovidApp
//
//  Created by jerome on 26/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import UserNotifications
import CoreLocation
import GoogleSignIn
import FacebookCore
import AuthenticationServices
import Security
import BLTNBoard

//MARK: - Protocols
protocol AppCoordinatorDelegate: class {
    func showEmailController()
    func showUserProfileController()
    func showMainController()
    func logOut()
    func addContent()
    func showSettings()
    func showHistory()
}

protocol DailyNotificationDelegate: class {
    func updateDailyNotification(for date: Date)
}

protocol ShareDelegate: class {
    func share(from controller: UIViewController?)
}

//MARK: - Launch
extension DefaultsKeys {
    var username: DefaultsKey<String?> { .init("username") }
    var onboardingWasShown: DefaultsKey<Bool> { .init("onboardingWasShown", defaultValue: false) }
    var initialValuesFilled: DefaultsKey<Bool> { .init("initialValuesFilled", defaultValue: false) }
    var alreadyRequestedNotifications: DefaultsKey<Bool> { .init("alreadyRequestedNotifications", defaultValue: false) }
    var notificationsEnabled: DefaultsKey<Bool> { .init("notificationsEnabled", defaultValue: false) }
    var collectedFirstData: DefaultsKey<Bool> { .init("collectedFirstData", defaultValue: false) }
    var hourForNotification: DefaultsKey<Date?> { .init("hourForNotification", defaultValue: nil) }
    var dailyNotificationId: DefaultsKey<String?> { .init("dailyNotificationId", defaultValue: nil) }
}

fileprivate var onboardingWasShown: Bool {
    return Defaults[\.onboardingWasShown]
}

fileprivate enum LaunchInstructor {
    case main, onboarding
    
    static func configure(
        tutorialWasShown: Bool = onboardingWasShown) -> LaunchInstructor {
        return .main
//        switch tutorialWasShown {
//        case false: return .onboarding
//        case true: return .main
//        }
    }
}

//MARK: - AppCoordinator
class AppCoordinator: Coordinator<DeepLink> {
    
    let mainController = MainViewController.create()
    let loginController = LoginViewController.create()
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(mainController, hideBar: true, animated: false)
        loginController.coordinatorDelegate = self
        mainController.shareDelegate = self
        mainController.coordinatorDelegate = self
        customize()
        UNUserNotificationCenter.current().delegate = self
        if Defaults[\.dailyNotificationId] == nil {
            Defaults[\.dailyNotificationId] = UUID().uuidString
            print("🐞 SET - \(String(describing: Defaults[\.dailyNotificationId]))")
        }
    }
    
    private func customize() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = Palette.basic.primary.color
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
    }
    
    func open(from link: DeepLink) {
        switch link {
        case .share(let userId): ()
            
        default: ()
        }
    }
    
    override func start() {
        configureGoogleSignIn()
        
        switch instructor {
        case .onboarding:
            presentOnboardingFlow()
            
        case .main:
            guard Constants.skipLogin == false else {
                showMainController()
                return
            }
            
            if SessionController().userLoggedIn == false {
                router.setRootModule(loginController, hideBar: true, animated: false)
            } else if SessionController().userProfileCompleted == false {
                router.setRootModule(loginController, hideBar: true, animated: false)
                showUserProfileController()
            } else {
                showMainController()
                checkIfSessionExpired()
            }
        }
    }
    
    func configureGoogleSignIn() {
        GIDSignIn.sharedInstance()?.clientID = SessionController.googleId
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let scheme = url.scheme {
            switch scheme {
            case DeepLink.scheme:
                if let link = DeepLink.from(route: (url.host ?? "") + url.path) {
                    open(from: link)
                }
                
            default:
                let handled = ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: sourceApplication, annotation: annotation)
                guard handled == false else {
                    return true
                }
                return GIDSignIn.sharedInstance()?.handle(url) ?? false
            }
        }
        return false
    }
    
    func presentOnboardingFlow() {
        SessionController().clear()
        let onboarding = OnboardingViewController.create()
        onboarding.modalPresentationStyle = .overFullScreen
        onboarding.delegate = self
        mainController.present(onboarding, animated: true)
    }
    
    
    var bulletinManager: BLTNItemManager?

    func showBulletin(for item: BLTNItem) {
        bulletinManager = BLTNItemManager(rootItem: item)
        if #available(iOS 12.0, *) {
            bulletinManager?.backgroundViewStyle = .blurredDark
        }
        bulletinManager?.showBulletin(above: mainController)
    }

    lazy var notificationItem: BLTNPageItem = {
        let page = BLTNPageItem(title: "ask notification".local())
        page.requiresCloseButton = false
        page.image = UIImage(named: "sharePhone")
        page.descriptionText = "ask for notification".local()
        page.actionButtonTitle = "Activate notification".local()

        page.actionHandler = { item in
            self.bulletinManager?.dismissBulletin()
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
                guard let self = self else { return }
                Defaults[\.alreadyRequestedNotifications] = true
                Defaults[\.notificationsEnabled] = granted
                if granted {
                    self.updateNotificationsForDefaultAlarm()
                }
            }
        }
        return page
    } ()
    
    func updateNotificationsForDefaultAlarm() {
        var compo = DateComponents()
        compo.hour = 10
        if let date = Calendar.current.date(from: compo) {
            updateDailyNotification(for: date)
        }
    }
    
    func askForNotification() {
        if Defaults[\.alreadyRequestedNotifications] == false {
            showBulletin(for: notificationItem)
        }
    }
    
    private func checkIfSessionExpired() {
        guard let rawLoginOrigin = Defaults[\.loginOrigin], let loginOrigin = SessionController.LoginOrigin.init(rawValue: rawLoginOrigin) else { return }
        switch loginOrigin {
        case .apple: if #available(iOS 13.0, *) { checkIfAppleSessionExpired() }
        case .google: checkIfGoogleSessionExpired()
        case .facebook: checkIfFacebookSessionExpired()
        }
    }
    
    private func checkIfGoogleSessionExpired() {
    }
    
    private func checkIfFacebookSessionExpired() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AccessTokenDidChange, object: nil, queue: nil) { notification in
            if let accessTokenExpired = notification.userInfo?[AccessTokenDidExpireKey] {
                print("☹ \(accessTokenExpired)")
            }
        }
    }
    
    @available(iOS 13.0, *)
    private func checkIfAppleSessionExpired() {
        guard let userIdentifier = SessionController().appleUserData?.identifier else { return }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized: break // The Apple ID credential is valid.
            case .revoked, .notFound:
                self.logOut()
                DispatchQueue.main.async {
                    MessageManager.show(.sso(.userWasLoggedOut))
                }
                
            default: break
            }
        }
    }
}

//MARK: - AppCoordinator extensions
extension AppCoordinator: CloseDelegate {
    func close(_ controller: UIViewController) {
        
        defer {
            // recheck for controller to ask for notification once controller has been dismiss
            mainController.dismiss(animated: true) { [weak self] in
                switch controller {
                case is OnboardingViewController:
                    self?.addContent()
                    
                default: ()
                }
            }
            start()
        }
        
        switch controller {
        case is OnboardingViewController:
            Defaults[\.onboardingWasShown] = true
            
        default: ()
        }
    }
}

extension AppCoordinator: AppCoordinatorDelegate {
    func showHistory() {
        let ctrl = HistoryViewController.create()
        router.push(ctrl, animated: true, completion: nil)
    }
    
    func showSettings() {
        let coord = AccountsCoordinator()
        addChild(coord)
        coord.start()
        router.present(coord, animated: true)
    }
    
    func showEmailController() {
        let email = AskEmailViewController.create()
        email.coordinatorDelegate = self
        router.setRootModule(email, hideBar: true, animated: true)
    }
    
    func showUserProfileController() {
        let profile = AskProfileViewController.create()
        profile.coordinatorDelegate = self
        router.setRootModule(profile, hideBar: true, animated: true)
    }
    
    func showMainController() {
        router.setRootModule(mainController, hideBar: false, animated: true)
        if Defaults[\.initialValuesFilled] == false {
//            self.showInitialMetrics()
        }
        // add a callback to check if the user denied notifications then enables them....
         if Defaults[\.alreadyRequestedNotifications] == true, Defaults[\.hourForNotification] == nil {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
                guard let self = self else { return }
                if granted {
                    self.updateNotificationsForDefaultAlarm()
                }
            }
        }
    }
    
    func logOut() {
        mainController.dismiss(animated: true, completion: nil)
        SessionController().logOut()
        start()
    }
    
    func addContent() {
        switch onboardingWasShown {
        case false:
            Defaults[\.onboardingWasShown] = true
            presentOnboardingFlow()
            
        case true: chooseContent()
        }
    }
    
    private func chooseContent() {
        let actionSheet = UIAlertController(title: "Choose content".local(), message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = Palette.basic.primary.color
        
        ShareModel.ModelType.allCases.forEach { model in
            actionSheet.addAction(UIAlertAction(title: model.displayName, style: .default, handler: { [weak self] _ in
                self?.add(content: model)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel".local(), style: .cancel, handler: nil))
        
        mainController.present(actionSheet, animated: true, completion: nil)
    }
    
    private func add(content: ShareModel.ModelType) {
        let model = AddContentCoordinator(content: content)
        addChild(model)
        model.start()
        router.present(model, animated: true)
    }
}

extension AppCoordinator: ShareDelegate {
    func share(from controller: UIViewController? = nil) {
        
        if #available(iOS 13.0, *) {
            guard let url = URL(string: String(format: "share format".local(), SessionController().email ?? "")) else { return }
            let metaData = LinkPresentationItemSource.metaData(title: "share from CovidApp".local(), url: url, fileName: "shareImageData", fileType: "png")
            let metadataItemSource = LinkPresentationItemSource(metaData: metaData)
            let activity = UIActivityViewController(activityItems: [metadataItemSource], applicationActivities: [])
            (controller ?? mainController).present(activity, animated: true)
        } else {
            let sharedString = String(format: "share format".local(), SessionController().email ?? "")
            let image = UIImage(named:"AppIcon60x60")!
            (controller ?? mainController).showShareViewController(with:[sharedString, image])
        }
    }
}

extension AppCoordinator: DailyNotificationDelegate {
        
    func updateDailyNotification(for date: Date) {
        Defaults[\.hourForNotification] = date
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "It's time".local()
        content.body = "Answer your 5 questions".local()
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
//        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date().addingTimeInterval(15))
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // removes previous notifications just in case...
        center.removeAllPendingNotificationRequests()
        let request = UNNotificationRequest(identifier: Defaults[\.dailyNotificationId]!, content: content, trigger: trigger)
        print("🐞 - UPDATE NOTIF - \(String(describing: Defaults[\.dailyNotificationId]))")
        center.add(request)
    }
}

extension AppCoordinator: UNUserNotificationCenterDelegate {
    func handleTapOn(_ request: UNNotificationRequest) {
        // if it was a local notification, we have it in our container notificationDatas
        if request.identifier == Defaults[\.dailyNotificationId] {
//            collectDailyMetrics()
        } else { // otherwise it is a remote notification
            //TODO:
//            handleRemoteNotificationData(request.content.userInfo, title: request.content.title, body: request.content.body)
        }
    }
    
    /// called when the user clicks on a specific action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler()
        }
        print("🐞 - GET NOTIF - \(String(describing: Defaults[\.dailyNotificationId]))")
        // open a notification from outside the app
        handleTapOn(response.notification.request)
    }
    
    /// called when a notification is delivered to the foreground app
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
