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
    override init(router: RouterType) {
        super.init(router: router)
    }
    
    override func toPresentable() -> UIViewController {
        return  accountsViewController
    }
}
