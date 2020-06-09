//
//  AddPictureViewModel.swift
//  PlatDuJour
//
//  Created by GG on 06/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import Photos

protocol UpdateButtonDelegate: class {
    func updateButton(_ enabled: Bool)
}

class AddContentViewModel: NSObject {
    private enum CellType {
        case asset(_ field: ShareModel.Field), singleField(_ field: ShareModel.Field), description, date
    }
    private var cellTypes: [CellType] = []
    weak var showPickerDelegate: AddPictureCellDelegate? = nil
    weak var updateButtonDelegate: UpdateButtonDelegate? = nil
    var observation: NSKeyValueObservation?
    private var content: ShareModel.ModelType
    
    // dish picture model
    private (set) var pictureModel: ShareModel!
    func update(_ image: UIImage) {
        pictureModel.update(image)
        isValid = pictureModel.isValid
    }
    func update(_ asset: PHAsset) {
        pictureModel.update(asset)
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
    func update(_ date: Date) {
        pictureModel.update(date)
        isValid = pictureModel.isValid
    }
    
    deinit {
        print("💀 DEINIT \(URL(fileURLWithPath: #file).lastPathComponent)")
        observation?.invalidate()
    }
    
    @objc dynamic var isValid: Bool = true
    
    init(content: ShareModel.ModelType) {
        self.content = content
        cellTypes = content.fields.map({ field -> CellType in
            switch field {
            case .picture: return .asset(.picture)
            case .asset: return .asset(.asset)
            case .price: return .singleField(.price)
            case .dishName: return .singleField(.dishName)
            case .restaurantName: return .singleField(.restaurantName)
            case .eventName: return .singleField(.eventName)
            case .description: return .description
            case .date: return .date
            }
        })
        pictureModel = ShareModel(model: content)
        super.init()
        observation = observe(\.isValid,
                              options: [.old, .new]
        ) { [weak self] _, change in
            self?.updateButtonDelegate?.updateButton(change.newValue ?? false)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView) {        
        switch cellTypes[indexPath.row] {
        case .asset: showPickerDelegate?.showImagePicker()
        case .singleField(let field):
            guard let cell = tableView.cellForRow(at: indexPath) as? AddSimpleFieldCell else {
                return
            }
            cell.textField.isUserInteractionEnabled = true
            cell.textField.becomeFirstResponder()
            
        case .description:
            guard let cell = tableView.cellForRow(at: indexPath) as? AddDescriptionCell else {
                return
            }
            cell.textView.becomeFirstResponder()
            
        case .date:
            guard let cell = tableView.cellForRow(at: indexPath) as? AddDateCell else {
                return
            }
            tableView.beginUpdates()
            cell.isExpanded.toggle()
            tableView.endUpdates()
        }
    }
}

extension AddContentViewModel: FieldCellDelegate {
    func textFieldShouldReturn(_ textField: UITextField, for field: ShareModel.Field) -> Bool {
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
            
            default: ()
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
        case .asset(let field):
            guard let cell: AddPictureCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.delegate = showPickerDelegate
            cell.configure(with: pictureModel.image)
            return cell
            
        case .singleField(let field):
            guard let cell: AddSimpleFieldCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: field, value: pictureModel.value(for: field))
            cell.fieldDelegate = self
            return cell
                
        case .description:
            guard let cell: AddDescriptionCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: pictureModel.contentDescription)
            cell.delegate = self
            return cell
            
        case .date:
            guard let cell: AddDateCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: pictureModel.eventDate)
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

extension AddContentViewModel: AddDateCellDelegate {
    func dateChanged(_ date: Date) {
        update(date)
    }
}
