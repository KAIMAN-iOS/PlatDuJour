//
//  SelectAccountsViewController.swift
//  PlatDuJour
//
//  Created by GG on 17/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class SelectAccountsViewController: UIViewController {

    static func create() -> SelectAccountsViewController {
        return SelectAccountsViewController.loadFromStoryboard(identifier: "SelectAccountsViewController", storyboardName: "AddContent")
    }
    
    private var accountsViewController: AccountsViewController!
    private let accountsCoordinator = AccountsCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let ctrl = children.compactMap({ $0 as? AccountsViewController }).first else {
            fatalError()
        }
        accountsViewController = ctrl
        ctrl.coordinatorDelegate = accountsCoordinator
        // Do any additional setup after loading the view.
    }
}
