//
//  AddPictureCell.swift
//  PlatDuJour
//
//  Created by GG on 05/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import AVKit
import SwiftyUserDefaults

protocol AddPictureCellDelegate: class {
    func showImagePicker()
}

class AddPictureCell: UITableViewCell {

    @IBOutlet var takePictureButton: UIButton!
    @IBOutlet var picture: UIImageView!
    weak var informationDelegate: InformationDelegate? = nil
    lazy var player: AVPlayerViewController = AVPlayerViewController()
    lazy var longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected))
    weak var delegate: AddPictureCellDelegate? = nil
    
    @IBAction func takePicture(_ sender: Any) {
        delegate?.showImagePicker()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDefaultSelectedBackground()
        contentView.addGestureRecognizer(longPress)
    }
    
    func configure(with model: ShareModel) {
        
        switch (model.image, model.mediaURL) {
        case (let image, nil) where image != nil:
            picture.image = image
            takePictureButton.setTitle(nil, for: .normal)
            takePictureButton.setImage(nil, for: .normal)
            takePictureButton.isHidden = false
            
        case (nil, let url) where url != nil:
            player.view.frame = picture.bounds
            if player.view.superview == nil {
                picture.addSubview(player.view)
                DispatchQueue.main.async { [unowned self] in
                    self.informationDelegate?.showInformation(for: .hintChoosePictureFromVideo)
                }
            }
            player.player = AVPlayer(url: url!)
            picture.isUserInteractionEnabled = true
            takePictureButton.setTitle(nil, for: .normal)
            takePictureButton.setImage(nil, for: .normal)
            if Defaults[\.videoPlayerTouchWarningWasShown] == false {
                Defaults[\.videoPlayerTouchWarningWasShown] = false
            }
            takePictureButton.isHidden = true
            
        default:
            takePictureButton.setTitle("Take picture".local(), for: .normal)
            takePictureButton.setImage(UIImage(named: "add"), for: .normal)
            takePictureButton.isHidden = false
        }
    }
    
    @objc private func longPressDetected() {
        delegate?.showImagePicker()
    }
}
