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
    return try User(identifier: json => "identifier",
                    lastName: json => "lastName",
                    firstName: json => "firstName",
                    age: json => "age")
  }
}
