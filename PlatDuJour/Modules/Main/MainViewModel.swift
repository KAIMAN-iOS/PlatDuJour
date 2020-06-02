//
//  MainViewModel.swift
//  CovidApp
//
//  Created by jerome on 30/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import Foundation

enum CollectionViewType {
    case metrics, friends
}

class MainViewModel {
    weak var shareDelegate: ShareDelegate? = nil
    weak var coordinatorDelegate: AppCoordinatorDelegate? = nil
}
