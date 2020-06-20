//
//  DataManager.swift
//  CovidApp
//
//  Created by jerome on 02/04/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import UIKit

typealias StorageKey = String
protocol StorableKey {
    var key: StorageKey { get }
}
enum DataManagerKey: String, StorableKey {
    case models = "models"
    case currentUser = "CurrentUser"
    
    var key: StorageKey {
        return StorageKey(rawValue)
    }
}

class DataManager {
    static let instance: DataManager = DataManager()
    private var storage = DataStorage()
    let saveQueue = DispatchQueue.init(label: "ModelBackgroundSave", qos: .background)
    
    private init() {
        if let models: [ShareModel] = try? storage.fetch(for: DataManagerKey.models.key) {
            self.models = models
        }
    }

    func store(_ user: CurrentUser) {
        do {
            try DataManager.instance.storage.save(user)
        } catch {

        }
    }
    
    func retrieveUser() throws -> CurrentUser {
        return try retrieve(for: DataManagerKey.currentUser.key)
    }
    
    func retrieve<T: Decodable>(for key: StorageKey) throws -> T {
        do {
            return try DataManager.instance.storage.fetch(for: key)
        }
        catch {
            throw StorageError.notFound
        }
    }
    
    
    static func save(_ image: UIImage) throws -> URL {
        try DataManager.instance.storage.save(image)
    }
    
    static func fetchImage(at url: URL) throws -> UIImage? {
        try DataManager.instance.storage.fetchImage(at: url)
    }
    
    static func copyMovie(at path: URL) throws -> URL {
        try DataManager.instance.storage.copyMovie(at: path)
    }
    
    private (set) var models: [ShareModel] = []
    static func save(_ model: ShareModel) throws {
        instance.saveQueue.async {
            DataManager.instance.models.append(model)
            try? DataManager.instance.storage.save(DataManager.instance.models, for: DataManagerKey.models.key)
        }
    }
}
