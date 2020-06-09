//
//  AddDateCell.swift
//  PlatDuJour
//
//  Created by GG on 09/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

protocol AddDateCellDelegate: class {
    func dateChanged(_ date: Date)
}

class AddDateCell: UITableViewCell {
    
    private static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .short
        df.locale = .current
        return df
    } ()
    private static var timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .none
        df.locale = .current
        return df
    } ()
    @IBOutlet var title: UILabel!  {
        didSet {
            title.set(text: ShareModel.Field.date.description, for: .default)
        }
    }

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!  {
        didSet {
            datePicker.minimumDate = Date()
            datePicker.isHidden = true
            datePicker.locale = .current
        }
    }
    var isExpanded: Bool = false  {
        didSet {
            datePicker.isHidden = isExpanded == false
        }
    }
    weak var delegate: AddDateCellDelegate? = nil
    private var date: Date = Date()  {
        didSet {
            delegate?.dateChanged(datePicker.date)
            dateLabel.set(text: AddDateCell.dateFormatter.string(from: date) + " - " + AddDateCell.timeFormatter.string(from: date), for: .default, textColor: Palette.basic.secondaryTexts.color)
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        addDefaultSelectedBackground()
    }

    @IBAction func dateChanged(_ sender: Any) {
        date = datePicker.date
    }
    
    func configure(with date: Date?) {
        self.date = date ?? Date()
        datePicker.date = self.date
    }
}
