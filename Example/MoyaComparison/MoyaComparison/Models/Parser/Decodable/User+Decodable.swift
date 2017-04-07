//
//  User+Decodable.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 07/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import Decodable

extension User: Decodable {
  static func decode(_ json: Any) throws -> User {
    return try User(identifier: json => KeyPath(JSONKeys.identifier),
                    lastName: json => KeyPath(JSONKeys.lastName),
                    firstName: json => KeyPath(JSONKeys.firstName),
                    age: json => KeyPath(JSONKeys.age))
  }
}
