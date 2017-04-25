//
//  NetworkStackError.swift
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

public enum NetworkStackError: Error {
  /// No internet, roaming off, data not allowed, call active, …
  case noInternet(error: NSError)
  /// DNS Lookup failed, Host unreachable, …
  case serverUnreachable(error: NSError)
  /// Invalid request, Fail to parse JSON, Unable to decode payload…
  case badServerResponse(error: NSError)
  /// Response in 4xx-5xx range
  case http(httpURLResponse: HTTPURLResponse, data: Data?)
  /// Fail to parse response
  case parseError
  /// Other, unclassified error
  case otherError(error: NSError)
  /// Request building has failed
  case requestBuildFail
  /// Upload manager has not been setup
  case uploadManagerIsNotSet
  /// Unknown
  case unknown
}
