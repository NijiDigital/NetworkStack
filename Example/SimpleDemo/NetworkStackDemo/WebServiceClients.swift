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
import RxSwift

struct VideoWebServiceClient {
  let networkStack: NetworkStack
  
  func fetchVideo(identifier: Int) -> Observable<Video> {
    let requestParameters = RequestParameters(method: .get,
                             route: Route.video(identifier: identifier))
    
    return self.networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .map({ (_, json: Any) -> Video in
				return try JSONDecoder().decode(Video.self, from: json as! Data)
      })
  }
  
  func deleteVideo(identifier: Int) -> Observable<Void> {
    let requestParameters = RequestParameters(method: .delete,
                             route: Route.video(identifier: identifier))
    
    return self.networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
}
