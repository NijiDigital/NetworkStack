//
//  CustomAPI+parameters.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 23/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation

extension CustomAPI {
  public var parameters: [String: Any]? {
    switch self {
    case .authent(let email, let passwd):
      let stringToEncode: String = String(format: "%@:%@", email, passwd)
      guard let credentialData: Data = stringToEncode.data(using: .utf8) else {
        logger.error(.webServiceClient, "Failed to encod data, user:\(email), password:\(passwd)")
        return nil
      }
      let base64Credentials: String = credentialData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
      return ["Authorization": "Basic \(base64Credentials)"]
    default:
      return nil
    }
  }
}
