//
//  AccountsViewController.swift
//  PlatDuJour
//
//  Created by GG on 07/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    static func create() -> AccountsViewController {
        return AccountsViewController.loadFromStoryboard(identifier: "AccountsViewController", storyboardName: "Accounts")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
