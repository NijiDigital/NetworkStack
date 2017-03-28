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
  public static func fetchAllUsers() -> RequestParameters {
    return RequestParameters(method: .get,
                             route: Route.users())
  }
  
  public static func fetchUser(identifier: Int) -> RequestParameters {
    return RequestParameters(method: .get,
                             route: Route.user(identifier: identifier))
  }
  
  public static func updateUser(identifier: Int, parameters: Alamofire.Parameters) -> RequestParameters {
    return RequestParameters(method: .put,
                             route: Route.user(identifier: identifier),
                             parameters: parameters,
                             parametersEncoding: URLEncoding.httpBody)
  }
  
  public static func addUser(parameters: Alamofire.Parameters) -> RequestParameters {
    return RequestParameters(method: .delete,
                             route: Route.users(),
                             parameters: parameters,
                             parametersEncoding: URLEncoding.httpBody)
  }
  
  public static func deleteUser(identifier: Int) -> RequestParameters {
    return RequestParameters(method: .post,
                             route: Route.user(identifier: identifier))
  }
}
