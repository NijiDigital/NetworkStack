//
//  SessionManagerFactory.swift
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

import Foundation
import Alamofire

public struct SessionManagerFactory {
  
  // MARK: Request session manager
  
  static func sessionManager(defaultHTTPHeaders: Alamofire.HTTPHeaders?,
                             requestTimeout: TimeInterval = 60.0) -> Alamofire.SessionManager {
    let configuration = URLSessionConfiguration.default
    
    if let defaultHTTPHeaders = defaultHTTPHeaders {
      configuration.httpAdditionalHeaders = defaultHTTPHeaders
    }
    
    configuration.timeoutIntervalForRequest = requestTimeout
    
    return self.sessionManager(withConfiguration: configuration)
  }
  
  // MARK: Upload session manager
  
  static func backgroundUploadSessionManager(withIdentifier identifier: String) -> Alamofire.SessionManager {
    let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
    return self.sessionManager(withConfiguration: configuration)
  }
  
  static func backgroundUploadSessionManager(withAppGroupIdentifier appGroupIdentifier: String) -> Alamofire.SessionManager {
    let configuration = URLSessionConfiguration.background(withIdentifier: appGroupIdentifier)
    configuration.sharedContainerIdentifier = appGroupIdentifier
    return self.sessionManager(withConfiguration: configuration)
  }
  
  // MARK: Common
  
  static func sessionManager(withConfiguration configuration: URLSessionConfiguration) -> Alamofire.SessionManager {
    return Alamofire.SessionManager(configuration: configuration)
  }
}
