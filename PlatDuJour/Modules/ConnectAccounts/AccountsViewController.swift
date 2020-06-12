//
//  AccountsViewController.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!  {
        didSet {
            tableView.commonInit()
        }
    }

    static func create() -> AccountsViewController {
        return AccountsViewController.loadFromStoryboard(identifier: "AccountsViewController", storyboardName: "Accounts")
    }
    
    let viewModel = AccountsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK: UITableViewDelegate
extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeader(in: section)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.header(for: section)
    }
}

//MARK: UITableViewDataSource
extension AccountsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.configureCell(at: indexPath, in: tableView)
    }
}

