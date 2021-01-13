//
//  AskCredential.swift
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

import UIKit
import RxSwift

/** 

AskCredential

# Description

This struct define the behavior when NetworkStack can't find how to provide token for request which need authorization.

# Usage

- Use triggerCondition to define for what error you need to call the handler.
by default 401 error trigger handler.

- Your provided handler must fetch new token and update the NetworkStack with it.

*/
public struct AskCredential {
  
  // MARK: - Type aliases
  
  public typealias AskCredentialHandler = (() -> Observable<Void>)
  public typealias AskCredentialTriggerCondition = ((Error) -> Bool)
  
  // MARK: - Properties
  
  public var triggerCondition: AskCredentialTriggerCondition
  public var handler: AskCredentialHandler
  
  // MARK: - Setup
  
  public init(triggerCondition: @escaping AskCredentialTriggerCondition, handler: @escaping AskCredentialHandler) {
    self.triggerCondition = triggerCondition
    self.handler = handler
  }
  
  public init(handler: @escaping AskCredentialHandler) {
    self.handler = handler
    self.triggerCondition = AskCredential.defaultTriggerCondition
  }
  
  // MARK: - Private
  
  private static func defaultTriggerCondition(error: Error) -> Bool {
    var shouldAskCredentials = false
    if case NetworkStackError.http(httpURLResponse: let httpURLResponse, data: _) = error, httpURLResponse.statusCode == 401 {
      shouldAskCredentials = true
    }
    return shouldAskCredentials
  }

}
