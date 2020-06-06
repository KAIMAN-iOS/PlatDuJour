//
//  AddPictureCoordinator.swift
//  PlatDuJour
//
//  Created by GG on 04/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

protocol AddPictureCoordinatorDelegate: class {
    func showTemplates(for image: UIImage)
    func updload(_ picture: UIImage)
}

class AddPictureCoordinator: Coordinator<DeepLink> {
    
    lazy var addPictureController: AddPictureViewController = AddPictureViewController.create(with: self)
    init() {
        let appNavigationController: UINavigationController = UINavigationController()
        appNavigationController.navigationBar.barTintColor = Palette.basic.primary.color
        let appRouter: RouterType = Router(navigationController: appNavigationController)
        super.init(router: appRouter)
        router.setRootModule(addPictureController, hideBar: false, animated: false)
    }
}

extension AddPictureCoordinator: AddPictureCoordinatorDelegate {
    func showTemplates(for image: UIImage) {
        
    }
    
    func updload(_ picture: UIImage) {
        
    }
}
