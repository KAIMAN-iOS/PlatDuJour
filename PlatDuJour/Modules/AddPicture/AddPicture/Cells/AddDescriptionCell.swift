//
//  AddDescriptionCell.swift
//  PlatDuJour
//
//  Created by GG on 05/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

protocol AddDescriptionCellDelegate: class {
    func didEndEditing(with text: String?)
}

class AddDescriptionCell: UITableViewCell {

    static let maxDigits = 250
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet var textView: UITextView!  {
        didSet {
            textView.delegate = self
        }
    }
    weak var delegate: AddDescriptionCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        addDefaultSelectedBackground()
    }
    
    func configure(with text: String?) {
        textView.text = text
    }
}

extension AddDescriptionCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var shouldChange = true
        if let textviewText = textView.text,
           let textRange = Range(range, in: textviewText) {
           let updatedText = textviewText.replacingCharacters(in: textRange,
                                                      with: text)
            shouldChange = updatedText.count < AddDescriptionCell.maxDigits
        }
        if shouldChange {
            countDownLabel.set(text: "\(AddDescriptionCell.maxDigits - textView.text.count)", for: .footnote, textColor: Palette.basic.mainTexts.color)
        }
        return shouldChange
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        delegate?.didEndEditing(with: textView.text)
        return true
    }
}
