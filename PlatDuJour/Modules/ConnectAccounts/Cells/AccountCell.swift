//
//  AccountCell.swift
//  PlatDuJour
//
//  Created by GG on 12/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet var accountLogo: UIImageView!
    @IBOutlet var accountName: UILabel!
    @IBOutlet var accountStatus: UILabel!
    @IBOutlet var accountSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func changeAccountStatus(_ sender: UISwitch) {
    }
    
    func configure(with account: ShareAccountManager.AccountType) {
        accountLogo.image = account.icon
        accountName.set(text: account.displayName, for: .default)
        ShareAccountManager.shared.status(for: account) { [weak self] status in
            guard let self = self else { return }
            self.accountStatus.set(text: status.text(for: account, hasSwitch: self.accountSwitch.isHidden == false), for: .footnote, textColor: status == .logged ? Palette.basic.confirmation.color : Palette.basic.mainTexts.color)
        }
    }
}
 
