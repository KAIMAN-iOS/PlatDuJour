//
//  UITableViewCell+Extensions.swift
//  mtx
//
//  Created by Mikhail Demidov on 10/4/16.
//  Copyright © 2016 Cityway. All rights reserved.
//

import UIKit
import SnapKit

protocol CellRegistrable {
    var tableView: UITableView! { get }
    func register(cell: Identifiable.Type)
}

extension CellRegistrable {
    func register(cell: Identifiable.Type) {
        let nib = UINib(nibName: cell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell.identifier)
    }
}

protocol CellDequeueable: CellRegistrable {
    func dequeue<T>(index: IndexPath, cell: Identifiable.Type) -> T where T: UITableViewCell
}

extension CellDequeueable {
    func dequeue<T>(index: IndexPath, cell: Identifiable.Type = T.self) -> T where T: UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cell.identifier, for: index) as! T
    }
}

protocol CellSizable {
    static var cellHeight: CGFloat { get }
}

protocol Configurable {
    associatedtype T
    func configure(_: T)
}

extension UITableViewCell {
//    func addBackgroundCard(_ edgeInset: UIEdgeInsets = .zero, useShadow: Bool = true, cornerRadius: CGFloat = 5, to addView: UIView? = nil) {
//        let view = CardCellBackgroundView()
//        if let addView = addView {
//            addView.insertSubview(view, at: 0)
//            addView.clipsToBounds = false
//        } else {
//            contentView.insertSubview(view, at: 0)
//        }
//        view.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(edgeInset.top)
//            make.bottom.equalToSuperview().inset(edgeInset.bottom)
//            make.left.equalToSuperview().offset(edgeInset.left)
//            make.right.equalToSuperview().inset(edgeInset.right)
//        }
//        view.cornerRadius = cornerRadius
//        if useShadow == false {
//            view.shadowColor = .clear
//        }
//    }
    
    func addDefaultSelectedBackground(_ color: UIColor = Palette.basic.primary.color.withAlphaComponent(0.3)) {
        let view = UIView(frame: contentView.bounds)
        view.backgroundColor = color
        selectedBackgroundView = view
    }
}
