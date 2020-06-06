//
//  AddSimpleFieldCell.swift
//  PlatDuJour
//
//  Created by GG on 05/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AddSimpleFieldCell: UITableViewCell {
    
    static private let formatter: NumberFormatter = {
        let nb = NumberFormatter()
        nb.numberStyle = .currency
        return nb
    } ()
    enum Field {
        case price, restaurantName, dishName
        
        var description: String {
            switch self {
            case .price: return "price".local()
            case .restaurantName: return "restaurantName".local()
            case .dishName: return "dishName".local()
            }
        }
        
        var placeholder: String {
            switch self {
                case .price: return "price placeholder".local()
                case .restaurantName: return "restaurantName placeholder".local()
                case .dishName: return "dishName placeholder".local()
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .price: return .numberPad
            default: return .asciiCapable
            }
        }
    }

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var textField: UITextField!  {
        didSet {
            textField.delegate = self
        }
    }
    weak var textfieldDelegate: UITextFieldDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDefaultSelectedBackground()
    }

    private var field: Field!  {
        didSet {
            descriptionLabel.set(text: field.description, for: .default)
            textField.placeholder = field.placeholder
            textField.keyboardType = field.keyboardType
        }
    }

    func configure<T>(with field: Field, value: T?) {
        self.field = field
    }

}

extension AddSimpleFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            switch field {
            case .price:
            // TODO
                print("updateTtext \(updatedText)")
                
            default: ()
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textfieldDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textfieldDelegate?.textFieldShouldReturn?(textField) ?? true
    }
}
