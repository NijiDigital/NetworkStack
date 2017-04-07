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
  public static func fetchAllVideos() -> RequestParameters {
    return RequestParameters(method: .get,
                             route: Route.videos())
  }
  
  public static func fetchVideo(identifier: Int) -> RequestParameters {
    return RequestParameters(method: .get,
                             route: Route.video(identifier: identifier))
  }
  
  public static func updateVideo(identifier: Int, parameters: Alamofire.Parameters) -> RequestParameters {
    return RequestParameters(method: .put,
                             route: Route.video(identifier: identifier),
                             parameters: parameters,
                             parametersEncoding: URLEncoding.httpBody)
  }
  
  public static func addVideo(parameters: Alamofire.Parameters) -> RequestParameters {
    return RequestParameters(method: .post,
                             route: Route.videos(),
                             parameters: parameters,
                             parametersEncoding: URLEncoding.httpBody)
  }
  
  public static func deleteVideo(identifier: Int) -> RequestParameters {
    return RequestParameters(method: .delete,
                             route: Route.video(identifier: identifier))
  }
}
