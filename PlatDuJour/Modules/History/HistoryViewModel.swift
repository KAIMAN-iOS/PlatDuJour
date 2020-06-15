//
//  HistoryViewModel.swift
//  PlatDuJour
//
//  Created by GG on 15/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class HistoryViewModel {
    var items: [ShareModel] = {
        return DataManager.instance.models
    } ()
    
    func numberOfItems(in section: Int) -> Int {
        return items.count
    }
    
    func configureCell(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        if let cell: HistoryCell = collectionView.automaticallyDequeueReusableCell(forIndexPath: indexPath) {
            cell.configure(with: items[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func didSelectCell(at indexPath: IndexPath) {
    }
}
