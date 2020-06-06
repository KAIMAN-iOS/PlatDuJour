//
//  ChooseTemplateViewController.swift
//  PlatDuJour
//
//  Created by GG on 04/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class ChooseTemplateViewController: UIViewController {

    static func create(with delegate: AddPictureCoordinatorDelegate) -> ChooseTemplateViewController {
        let controller = ChooseTemplateViewController.loadFromStoryboard(identifier: "ChooseTemplateViewController", storyboardName: "AddPicture") as! ChooseTemplateViewController
        controller.coordinatorDelegate = delegate
        return controller
    }
    weak var coordinatorDelegate: AddPictureCoordinatorDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
