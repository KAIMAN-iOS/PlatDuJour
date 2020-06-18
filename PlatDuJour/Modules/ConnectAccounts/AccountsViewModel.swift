//
//  AccountsViewModel.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AccountsViewModel: NSObject {
    let accounts: [ShareAccountManager.AccountType] = ShareAccountManager.AccountType.allCases
    private var displayMode: AccountsViewController.DisplayMode!
    init(displayMode: AccountsViewController.DisplayMode) {
        self.displayMode = displayMode
    }
}

extension AccountsViewModel: TableViewModelable {
    func numberOfRows(in section: Int) -> Int {
        return accounts.count
    }
    
    func configureCell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        guard let cell: AccountCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: accounts[indexPath.row], showSwitch: displayMode.showSwitches)
        return cell
    }
    
    func willSelectRow(at indexPath: IndexPath) -> IndexPath? {
        return accounts[indexPath.row].isEnabled ? indexPath : nil
    }
}
