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
    let authHeaders: Alamofire.HTTPHeaders = ["Authorization": "Basic \(stringToEncode.convertTobase64())"]
    return RequestParameters(method: .get,
                             route: Route.authent(),
                             headers: authHeaders)
  }
  
  public static func refreshToken(_ refreshToken: String) -> RequestParameters {
    let parameters: Parameters = ["refresh_token": refreshToken]
    
    return RequestParameters(method: .post,
                             route: Route.refreshToken(),
                             parameters: parameters,
                             parametersEncoding: URLEncoding.httpBody)
  }
}
