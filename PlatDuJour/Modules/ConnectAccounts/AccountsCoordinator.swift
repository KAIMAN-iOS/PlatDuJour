//
//  AccountsCoordinator.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//
import UIKit

protocol AccountsCoordinatorDelegate: class {
    func switchState(for accoutType: ShareAccountManager.AccountType, completion: @escaping ((Bool) -> Void))
}

class AccountsCoordinator: Coordinator<DeepLink> {
    
    lazy var accountsViewController: AccountsViewController = AccountsViewController.create()
    init() {
        let appNavigationController: UINavigationController = UINavigationController()
        appNavigationController.navigationBar.barTintColor = Palette.basic.primary.color
        let appRouter: RouterType = Router(navigationController: appNavigationController)
        super.init(router: appRouter)
        router.setRootModule(accountsViewController, hideBar: false, animated: false)
        accountsViewController.coordinatorDelegate = self
    }
}

extension AccountsCoordinator: AccountsCoordinatorDelegate {
    func switchState(for accoutType: ShareAccountManager.AccountType, completion: @escaping ((Bool) -> Void)) {
        ShareAccountManager.shared.status(for: accoutType) { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .notLogged: ShareAccountManager.shared.askPermission(for: accoutType, from: self.accountsViewController, completion: completion)
            case .logged: ShareAccountManager.shared.logOut(for: accoutType, completion: completion)
            }
        }
    }
}
