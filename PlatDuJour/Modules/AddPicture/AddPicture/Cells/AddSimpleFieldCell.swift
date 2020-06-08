//
//  AddSimpleFieldCell.swift
//  PlatDuJour
//
//  Created by GG on 05/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

protocol FieldCellDelegate: class {
    func textFieldShouldReturn(_ textField: UITextField, for field: ShareModel.Field) -> Bool
}

class AddSimpleFieldCell: UITableViewCell {
    
    static private let formatter: NumberFormatter = {
        let nb = NumberFormatter()
        nb.numberStyle = .currency
        return nb
    } ()

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var textField: UITextField!  {
        didSet {
            textField.delegate = self
        }
    }
    weak var fieldDelegate: FieldCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDefaultSelectedBackground()
    }

    private var field: ShareModel.Field!  {
        didSet {
            descriptionLabel.set(text: field.description, for: .default)
            textField.placeholder = field.placeholder
            textField.keyboardType = field.keyboardType
        }
    }

    func configure<T>(with field: ShareModel.Field, value: T?) {
        self.field = field
        if let value =  value {
            textField.text = String(describing: value)
        }
    }

}

extension AddSimpleFieldCell: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = textField.text,
//           let textRange = Range(range, in: text) {
//           let updatedText = text.replacingCharacters(in: textRange,
//                                                       with: string)
//            switch field {
//            case .price:
//            // TODO
//                print("updateTtext \(updatedText)")
//                
//            default: ()
//            }
//        }
//        return true
//    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return fieldDelegate?.textFieldShouldReturn(textField, for: field) ?? true
    }
}
