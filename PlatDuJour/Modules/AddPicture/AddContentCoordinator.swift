//
//  AddPictureCoordinator.swift
//  PlatDuJour
//
//  Created by GG on 04/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import Photos

protocol AddPictureCoordinatorDelegate: class {
    func showTemplates(for image: UIImage)
    func updload(_ picture: UIImage)
    func showImagePicker(with type: UIImagePickerController.SourceType, mediaTypes: [String], delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
}

class AddContentCoordinator: Coordinator<DeepLink> {
    
    var addPictureController: AddContentViewController!
    init(content: ShareModel.ModelType) {
        let appNavigationController: UINavigationController = UINavigationController()
        appNavigationController.navigationBar.barTintColor = Palette.basic.primary.color
        let appRouter: RouterType = Router(navigationController: appNavigationController)
        super.init(router: appRouter)
        addPictureController = AddContentViewController.create(with: self, content: content)
        router.setRootModule(addPictureController, hideBar: false, animated: false)
    }
}

extension AddContentCoordinator: AddPictureCoordinatorDelegate {
    func showImagePicker(with type: UIImagePickerController.SourceType, mediaTypes: [String], delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let showPicker: () -> (Void) = { [weak self] in
            guard let self = self else { return }
            let picker = UIImagePickerController()
            picker.sourceType = type
            picker.mediaTypes = mediaTypes
            picker.delegate = delegate
//            self.router.present(picker, animated: true)
//            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.present(picker, animated: true, completion: nil)
            self.addPictureController.present(picker, animated: true, completion: nil)
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                showPicker()
            })
            
        case .authorized:
            showPicker()
            
        default: ()
        }
    }
    
    func showTemplates(for image: UIImage) {
        
    }
    
    func updload(_ picture: UIImage) {
        
    }
}
