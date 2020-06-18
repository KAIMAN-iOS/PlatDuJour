//
//  AccountsViewController.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    weak var coordinatorDelegate: AccountsCoordinatorDelegate? = nil
    @IBOutlet var tableView: UITableView!

    enum DisplayMode {
        case settings, share
        
        var showSwitches: Bool {
            switch self {
            case .settings: return false
            case .share: return true
            }
        }
    }
    
    var displayMode: DisplayMode = .settings {
        didSet {
            viewModel = AccountsViewModel(displayMode: displayMode)
        }
    }

    static func create(for displayMode: DisplayMode) -> AccountsViewController {
        let ctrl: AccountsViewController = AccountsViewController.loadFromStoryboard(identifier: "AccountsViewController", storyboardName: "Accounts")
        ctrl.displayMode = displayMode
        return  ctrl
    }
    
    var viewModel: AccountsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.commonInit()
    }
}


//MARK: UITableViewDelegate
extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinatorDelegate?.switchState(for: viewModel.accounts[indexPath.row], completion: { [weak self] success in
            self?.tableView.reloadRows(at: [indexPath], with: .fade)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeader(in: section)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.header(for: section)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return viewModel.willSelectRow(at: indexPath)
    }
}

//MARK: UITableViewDataSource
extension AccountsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.configureCell(at: indexPath, in: tableView)
    }
}

