//
//  AccountCell.swift
//  PlatDuJour
//
//  Created by GG on 12/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

protocol AccountStateDelegate: class {
    func stateChanged(for account: ShareAccountManager.AccountType)
}

class AccountCell: UITableViewCell {

    @IBOutlet var accountLogo: UIImageView!
    @IBOutlet var accountName: UILabel!
    @IBOutlet var accountStatus: UILabel!
    @IBOutlet var accountSwitch: UISwitch!  {
        didSet {
            accountSwitch.onTintColor = Palette.basic.primary.color
        }
    }
    let stateDelegate: AccountStateDelegate = ShareAccountManager.shared

    @IBAction func changeAccountStatus(_ sender: UISwitch) {
        stateDelegate.stateChanged(for: accountType)
    }
    
    private var accountType: ShareAccountManager.AccountType!
    func configure(with account: ShareAccountManager.AccountType, showSwitch: Bool) {
        accountType = account
        accountLogo.image = account.icon
        accountName.set(text: account.displayName, for: .default)
        ShareAccountManager.shared.status(for: account) { [weak self] status in
            guard let self = self else { return }
            self.accountSwitch.isOn = account.switchState && status == .logged
            self.accountSwitch.isEnabled = status == .logged
            self.accountStatus.set(text: status.text(for: account, hasSwitch: self.accountSwitch.isHidden == false), for: .footnote, textColor: status == .logged ? Palette.basic.confirmation.color : Palette.basic.mainTexts.color)
        }
        accountSwitch.isHidden = showSwitch == false
    }
}
 
