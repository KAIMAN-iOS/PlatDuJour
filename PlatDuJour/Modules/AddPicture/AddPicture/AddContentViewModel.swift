//
//  AddPictureViewModel.swift
//  PlatDuJour
//
//  Created by GG on 06/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

protocol UpdateButtonDelegate: class {
    func updateButton(_ enabled: Bool)
}

class AddContentViewModel: NSObject {
    private enum cellType {
        case picture, dishPrice, dishName, restaurantName, dishDescription
        
        var cellField: AddSimpleFieldCell.Field? {
            switch self {
            case .dishPrice: return .price
            case .dishName: return .dishName
            case .restaurantName: return .restaurantName
            default: return nil
            }
        }
    }
    private var cellTypes: [cellType] = [.picture, .dishPrice, .dishName, .restaurantName, .dishDescription]
    weak var showPickerDelegate: AddPictureCellDelegate? = nil
    weak var updateButtonDelegate: UpdateButtonDelegate? = nil
    var observation: NSKeyValueObservation?
    
    // dish picture model
    private (set) var pictureModel = ShareModel()
    func update(_ image: UIImage) {
        pictureModel.update(image)
        isValid = pictureModel.isValid
    }
    func update(_ price: Double) {
        pictureModel.update(price)
        isValid = pictureModel.isValid
    }
    func update(dishName name: String) {
        pictureModel.update(dishName: name)
        isValid = pictureModel.isValid
    }
    func update(restaurantName name: String) {
        pictureModel.update(restaurantName: name)
        isValid = pictureModel.isValid
    }    
    func update(dishDescription description: String) {
        pictureModel.update(dishDescription: description)
        isValid = pictureModel.isValid
    }
    
    deinit {
        print("💀 DEINIT \(URL(fileURLWithPath: #file).lastPathComponent)")
        observation?.invalidate()
    }
    
    @objc dynamic var isValid: Bool = true
    
    override init() {
        super.init()
        observation = observe(\.isValid,
                              options: [.old, .new]
        ) { [weak self] _, change in
            self?.updateButtonDelegate?.updateButton(change.newValue ?? false)
        }
    }
    
    private var currentSelectedField: AddSimpleFieldCell.Field? = nil
    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView) {
        currentSelectedField = cellTypes[indexPath.row].cellField
        
        switch cellTypes[indexPath.row] {
        case .picture: showPickerDelegate?.showImagePicker()
        case .dishPrice, .dishName, .restaurantName:
            guard let cell = tableView.cellForRow(at: indexPath) as? AddSimpleFieldCell else {
                return
            }
            cell.textField.isUserInteractionEnabled = true
            cell.textField.becomeFirstResponder()
            
        case .dishDescription:
            guard let cell = tableView.cellForRow(at: indexPath) as? AddDescriptionCell else {
                return
            }
            cell.textView.becomeFirstResponder()
        }
    }
}

extension AddContentViewModel: FieldCellDelegate {
    func textFieldShouldReturn(_ textField: UITextField, for field: AddSimpleFieldCell.Field) -> Bool {
        textField.isUserInteractionEnabled = false
        switch field {
        case .price:
            pictureModel.price = Double(textField.text ?? "")
            isValid = pictureModel.isValid
            
        case .restaurantName:
            pictureModel.restaurantName = textField.text
            isValid = pictureModel.isValid
            
        case .dishName:
            pictureModel.dishName = textField.text
            isValid = pictureModel.isValid
        }
        return true
    }
}

extension AddContentViewModel: TableViewModelable {
    func numberOfRows(in section: Int) -> Int {
        return cellTypes.count
    }
    
    func configureCell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch cellTypes[indexPath.row] {
        case .picture:
            guard let cell: AddPictureCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.delegate = showPickerDelegate
            cell.configure(with: pictureModel.image)
            return cell
            
        case .dishPrice:
            guard let cell: AddSimpleFieldCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: .price, value: pictureModel.price)
            cell.fieldDelegate = self
            return cell
            
        case .dishName:
            guard let cell: AddSimpleFieldCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: .dishName, value: pictureModel.dishName)
            cell.fieldDelegate = self
            return cell
            
        case .restaurantName:
            guard let cell: AddSimpleFieldCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: .restaurantName, value: pictureModel.restaurantName)
            cell.fieldDelegate = self
            return cell
            
        case .dishDescription:
            guard let cell: AddDescriptionCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: pictureModel.dishDescription)
            cell.delegate = self
            return cell
        }
    }
}

extension AddContentViewModel: AddDescriptionCellDelegate {
    func didEndEditing(with text: String?) {
        guard let text = text else { return }
        update(dishDescription: text)
    }
}
