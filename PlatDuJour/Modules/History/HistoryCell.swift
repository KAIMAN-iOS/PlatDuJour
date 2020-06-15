//
//  HistoryCell.swift
//  PlatDuJour
//
//  Created by GG on 15/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class HistoryCell: UICollectionViewCell {
    
    private static var formatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .short
        return df
    } ()
    @IBOutlet var image: UIImageView!
    @IBOutlet var date: UILabel!
    
    func configure(with model: ShareModel) {
        image.image = model.image
        date.set(text: HistoryCell.formatter.string(from: model.creationDate), for: .custom(.caption1, traits: nil), textColor: .white)
    }
}
 
