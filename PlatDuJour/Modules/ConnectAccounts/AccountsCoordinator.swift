//
//  AccountsCoordinator.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//
import UIKit

class AccountsCoordinator: Coordinator<DeepLink> {
    
    lazy var accountsViewController: AccountsViewController = AccountsViewController.create()
    init() {
        let appNavigationController: UINavigationController = UINavigationController()
        appNavigationController.navigationBar.barTintColor = Palette.basic.primary.color
        let appRouter: RouterType = Router(navigationController: appNavigationController)
        super.init(router: appRouter)
        router.setRootModule(accountsViewController, hideBar: false, animated: false)
    }
}
