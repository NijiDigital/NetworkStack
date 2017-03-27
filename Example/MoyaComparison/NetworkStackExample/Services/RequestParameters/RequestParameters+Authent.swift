//
// Copyright 2017 niji
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import NetworkStack
import Alamofire

extension RequestParameters {
  public static func authent(user: String, password: String) -> RequestParameters {
    let stringToEncode: String = String(format: "%@:%@", user, password)
    guard let credentialData = stringToEncode.data(using: .utf8) else {
      return RequestParameters(method: .get, route: Route.authent(), needsAuthorization: false, parameters: nil, parametersEncoding: URLEncoding.default, headers: nil)
    }
    let base64Credentials: String = credentialData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
    let authHeaders: Alamofire.HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
    return RequestParameters(method: .get, route: Route.authent(), needsAuthorization: false, parameters: nil, parametersEncoding: URLEncoding.default, headers: authHeaders)
  }
}
