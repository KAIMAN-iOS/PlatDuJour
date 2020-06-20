//
//  SelectAccountsViewController.swift
//  PlatDuJour
//
//  Created by GG on 17/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class SelectAccountsViewController: UIViewController {

    private var model: ShareModel!
    static func create(with model: ShareModel) -> SelectAccountsViewController {
        let ctrl: SelectAccountsViewController = SelectAccountsViewController.loadFromStoryboard(identifier: "SelectAccountsViewController", storyboardName: "AddContent")
        ctrl.model = model
        return ctrl
    }
    
    private var accountsViewController: AccountsViewController!
    private let accountsCoordinator = AccountsCoordinator(with: .share)
    private var observation: NSKeyValueObservation?
    @IBOutlet var publishButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let ctrl = children.compactMap({ $0 as? AccountsViewController }).first else {
            fatalError()
        }
        accountsViewController = ctrl
        accountsViewController.displayMode = .share
        ctrl.coordinatorDelegate = accountsCoordinator
        title = "Share".local()
        // Do any additional setup after loading the view.
        observation = ShareAccountManager.shared.observe(\.atLeastOneServiceIsActivated,
                              options: [.old, .new]
        ) { [weak self] _, change in
            self?.publishButton.isEnabled = change.newValue ?? false
        }
        publishButton.isEnabled = ShareAccountManager.AccountType.atLeastOneServiceIsActivated
    }
    
    @IBAction func publish(_ sender: Any) {
        try? DataManager.save(model)
    }
}
