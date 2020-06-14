//
//  InformationCell.swift
//  PlatDuJour
//
//  Created by GG on 14/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {

    enum InformationType {
        case hintChoosePictureFromVideo
        
        var backgroundColor: UIColor {
            switch self {
            case .hintChoosePictureFromVideo: return Palette.basic.confirmation.color
            }
        }
        var textColor: UIColor {
            switch self {
            case .hintChoosePictureFromVideo: return .white
            }
        }
        var text: String {
            switch self {
            case .hintChoosePictureFromVideo: return "hintChoosePictureFromVideo".local()
            }
        }
    }
    
    @IBOutlet var information: UILabel!
    
    func configure(with information: InformationType = .hintChoosePictureFromVideo) {
        contentView.backgroundColor = information.backgroundColor
        self.information.set(text: information.text, for: .custom(.caption1, traits: nil), textColor: information.textColor)
    }
}
