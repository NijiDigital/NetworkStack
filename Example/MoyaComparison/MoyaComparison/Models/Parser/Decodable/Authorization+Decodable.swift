//
//  Authorization+Decodable.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 07/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import Decodable

extension Authorization: Decodable {
  static func decode(_ json: Any) throws -> Authorization {
    return try Authorization(token: json => KeyPath(JSONKeys.token),
                             expirationDate: json => KeyPath(JSONKeys.expirationDate),
                             refreshToken: json => KeyPath(JSONKeys.refreshToken))
  }
}
