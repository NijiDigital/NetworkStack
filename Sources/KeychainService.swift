//
//  KeychainService.swift
//
//  Copyright © 2017 Niji. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import KeychainAccess
import RxSwift

open class KeychainService {
  
  // MARK: Constants
  
  private let accessTokenKey = "access_token"
  private let refreshTokenKey = "refresh_token"
  private let expirationDateKey = "expires_in"
  
  // MARK: Properties
  
  private let keychain: Keychain
  public let serviceType: String
  
  // MARK: Setup
  
  public init(serviceType: String) {
    self.serviceType = serviceType
    self.keychain = Keychain(service: serviceType)
  }    
  
  public func removeAll() throws {
    try self.keychain.removeAll()
  }
  
  // MARK: OAuth
  
  public var accessToken: String? {
    get {
      return self.keychain[accessTokenKey]
    }
    set {
        self.keychain[accessTokenKey] = newValue
    }
  }

  public var refreshToken: String? {
    get {
        return self.keychain[refreshTokenKey]
    }
    set {
        self.keychain[refreshTokenKey] = newValue
    }
  }
  
  public var expirationInterval: TimeInterval? {
    get {
      guard let intervalValue = self.keychain[expirationDateKey] else {
        return nil
      }
      return TimeInterval(intervalValue)
    }
    set {
      if let timeinterval = newValue as TimeInterval? {
        self.keychain[expirationDateKey] = String(timeinterval)
      } else {
        self.keychain[expirationDateKey] = nil
      }
    }
  }
  
  public var isAccessTokenValid: Bool {
    return self.accessToken != nil
  }
  
  public var isRefreshTokenValid: Bool {
    return self.refreshToken != nil
  }
}
