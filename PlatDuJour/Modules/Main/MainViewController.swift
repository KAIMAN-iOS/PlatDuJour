//
//  MainViewController.swift
//  CovidApp
//
//  Created by jerome on 26/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    weak var shareDelegate: ShareDelegate? = nil
    weak var coordinatorDelegate: AppCoordinatorDelegate? = nil
    static func create() -> MainViewController {
        guard let nav = UINavigationController.loadFromStoryboard(identifier: "MainNavigationController", storyboardName: "Main") as? UINavigationController,
            let main = nav.viewControllers.first as? MainViewController else {
                fatalError()
        }
        return main
    }
    @IBOutlet var addButton: UIButton!  {
        didSet {
            addButton.roundedCorners = true
        }
    }
    @IBOutlet var historyButton: ActionButton!
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.shareDelegate = shareDelegate
        viewModel.coordinatorDelegate = coordinatorDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SessionController().userLoggedIn == true {
            loadUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadUser() {
        MessageManager.show(.basic(.loadingPleaseWait), in: self)
    }
    
    @IBAction func add(_ sender: Any) {
    }
    
    @IBAction func showSettings(_ sender: Any) {
    }
    
    @IBAction func showPreviousDishes(_ sender: Any) {
    }
}
