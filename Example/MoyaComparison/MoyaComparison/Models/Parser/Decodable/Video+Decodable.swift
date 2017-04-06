//
//  Video+Decodable.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 07/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import Decodable

extension Video: Decodable {
  static func decode(_ json: Any) throws -> Video {
    return try Video()
  }
}
