//
//  AddPictureViewModel.swift
//  PlatDuJour
//
//  Created by GG on 06/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AddPictureViewModel {
    private enum cellType {
        case picture, dishPrice, dishName, restaurantName, dishDescription
    }
    private var cellTypes: [cellType] = [.picture, .dishPrice, .dishName, .restaurantName, .dishDescription]
    weak var showPickerDelegate: AddPictureCellDelegate? = nil
    
    // dish picture model
    private var pictureModel = PictureModel()
    func update(_ image: UIImage) {
        pictureModel.update(image)
    }
    func update(_ price: Double) {
        pictureModel.update(price)
    }
    func update(dishName name: String) {
        pictureModel.update(dishName: name)
    }
    func update(restaurantName name: String) {
        pictureModel.update(restaurantName: name)
    }    
    func update(dishDescription description: String) {
        pictureModel.update(dishDescription: description)
    }
}

extension AddPictureViewModel: TableViewModelable {
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
            return cell
            
        case .dishName:
            guard let cell: AddSimpleFieldCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: .dishName, value: pictureModel.dishName)
            return cell
            
        case .restaurantName:
            guard let cell: AddSimpleFieldCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: .restaurantName, value: pictureModel.restaurantName)
            return cell
            
        case .dishDescription:
            guard let cell: AddDescriptionCell = tableView.automaticallyDequeueReusableCell(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: pictureModel.dishDescription)
            return cell
        }
    }
}
