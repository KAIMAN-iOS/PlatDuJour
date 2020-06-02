//
//  User.swift
//  CovidApp
//
//  Created by jerome on 26/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import Foundation

class EmptyResponseData: Codable {
}

class CurrentUser: Codable {
    private (set) var id: Int
    private (set) var name: String
    private (set) var firstname: String
    
    init() {
        id = 0
        name = ""
        firstname = ""
    }
    
    var userName: String {
        return firstname + " " + name
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "lastname"
        case firstname = "firstname"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //mandatory
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        firstname = try container.decode(String.self, forKey: .firstname)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(firstname, forKey: .firstname)
    }
}
