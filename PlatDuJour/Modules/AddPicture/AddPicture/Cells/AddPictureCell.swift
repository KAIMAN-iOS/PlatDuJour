//
//  AddPictureCell.swift
//  PlatDuJour
//
//  Created by GG on 05/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import Photos

protocol AddPictureCellDelegate: class {
    func showImagePicker()
}

class AddPictureCell: UITableViewCell {

    @IBOutlet var takePictureButton: UIButton!
    @IBOutlet var picture: UIImageView!
    weak var delegate: AddPictureCellDelegate? = nil
    
    @IBAction func takePicture(_ sender: Any) {
        delegate?.showImagePicker()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDefaultSelectedBackground()
    }
    
    func configure(with image: UIImage?) {
        picture.image = image
        takePictureButton.setTitle(image != nil ? nil : "Take picture".local(), for: .normal)
        takePictureButton.setImage(image != nil ? nil : UIImage(named: "add"), for: .normal)
    }
    
    func configure(with asset: PHAsset?) {
        let image = asset != nil ? getAssetThumbnail(asset: asset!, size: CGSize(width: asset?.pixelWidth ?? 0, height: asset?.pixelHeight ?? 0)) : nil
        picture.image = image
        takePictureButton.setTitle(image != nil ? nil : "Take picture".local(), for: .normal)
        takePictureButton.setImage(image != nil ? nil : UIImage(named: "add"), for: .normal)
    }
    
    func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
}
