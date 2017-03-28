//
//  String+Base64Encoding.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 28/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation

extension String {
  func convertTobase64() -> String {
    guard let dataToConvert = self.data(using: .utf8) else {
      logger.error(.encoding, "Failed to encode string to base64 = \(self)")
      return ""
    }
    let base64String: String = dataToConvert.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
    return base64String
  }
}
