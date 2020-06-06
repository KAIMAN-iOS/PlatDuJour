//
//  AddDescriptionCell.swift
//  PlatDuJour
//
//  Created by GG on 05/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import GrowingTextView

class AddDescriptionCell: UITableViewCell {

    static let maxDigits = 250
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet var textView: GrowingTextView!  {
        didSet {
            textView.maxLength = AddDescriptionCell.maxDigits
            countDownLabel.set(text: "\(AddDescriptionCell.maxDigits - textView.text.count)", for: .footnote, textColor: Palette.basic.mainTexts.color)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDefaultSelectedBackground()
    }
    
    func configure(with text: String?) {
        textView.text = text
    }
}

extension AddDescriptionCell: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
}
