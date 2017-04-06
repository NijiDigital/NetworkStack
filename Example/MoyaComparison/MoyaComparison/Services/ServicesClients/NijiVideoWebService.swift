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

import Alamofire
import NetworkStack
import Foundation
import RxSwift
import JSONCodable

struct NijiVideoWebService: VideoWebServiceClient {
  var services: Services
  
  func fetchAllVideos() -> Observable<[Video]> {
    return self.services.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.fetchAllVideos())
      .flatMap({ (_, json: Any) -> Observable<[Video]> in
        return self.services.serializationJSONCodable.parse(objects: json)
      })
  }
  
  func fetchVideo(identifier: Int) -> Observable<Video> {
    return self.services.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.fetchVideo(identifier: identifier))
      .flatMap({ (_, json: Any) -> Observable<Video> in
        return self.services.serializationJSONCodable.parse(object: json)
      })
  }
  
  func update(video: Video) -> Observable<Void> {
    guard let json: JSONObject = try? video.toJSON() else {
      let error = SerializationServiceError.unexpectedParsing(object: video)
      LogModule.webServiceClient.error("Failed to parse video : \(error)")
      return Observable.error(error)
    }
    return self.services.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.updateVideo(identifier: video.identifier, parameters: json))
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
  
  func add(video: Video) -> Observable<Video> {
    guard let json: JSONObject = try? video.toJSON() else {
      let error = SerializationServiceError.unexpectedParsing(object: video)
      LogModule.webServiceClient.error("Failed to parse video : \(error)")
      return Observable.error(error)
    }
    return self.services.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.addVideo(parameters: json))
      .flatMap({ (_, json: Any) -> Observable<Video> in
        return self.services.serializationJSONCodable.parse(object: json)
      })
  }
  
  func deleteVideo(identifier: Int) -> Observable<Void> {
    return self.services.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.deleteVideo(identifier: identifier))
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
  
  /// Create fake video for Niji NetworkStack
  ///
  /// - Returns: fake created video
  func fakeVideoToAdd() -> Video {
    let video = Video()
    video.title = "NetworkStack by Niji"
    video.creationDate = Date()
    video.hasSponsors.value = true
    video.likeCounts = 10000
    video.statusCode.value = 10
    return video
  }
}
