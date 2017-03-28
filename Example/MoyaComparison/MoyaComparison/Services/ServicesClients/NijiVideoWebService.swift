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

struct NijiVideoWebService: VideoWebService {
  var webServices: WebServices
  
  func fetchAllVideos() -> Observable<[Video]> {
    let requestParameters = RequestParameters(method: .get,
                                              route: Route.videos(),
                                              needsAuthorization: false,
                                              parametersEncoding: URLEncoding.default)
    
    return self.webServices.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, json: Any) -> Observable<[Video]> in
        return self.webServices.serializationSwiftyJSON.parse(objects: json)
      })
  }
  
  func fetchVideo(identifier: Int) -> Observable<Video> {
    let requestParameters = RequestParameters(method: .get,
                                              route: Route.video(identifier: identifier),
                                              needsAuthorization: false,
                                              parametersEncoding: URLEncoding.default)
    return self.webServices.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, json: Any) -> Observable<Video> in
        return self.webServices.serializationSwiftyJSON.parse(object: json)
      })
  }
  
  func updateVideo(video: Video) -> Observable<Void> {
    guard let json: JSONObject = video.toJSON().dictionaryObject else {
      let error = SerializationServiceError.unexpectedParsing(object: video)
      logger.error(.webServiceClient, "Failed to parse video : \(error)")
      return Observable.error(error)
    }
    let parameters: Alamofire.Parameters = json
    let requestParameters = RequestParameters(method: .put,
                                              route: Route.video(identifier: video.identifier),
                                              needsAuthorization: false,
                                              parameters: parameters,
                                              parametersEncoding: URLEncoding.httpBody)
    return self.webServices.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
  
  func addVideo(video: Video) -> Observable<Video> {
    guard let json: JSONObject = video.toJSON().dictionaryObject else {
      let error = SerializationServiceError.unexpectedParsing(object: video)
      logger.error(.webServiceClient, "Failed to parse video : \(error)")
      return Observable.error(error)
    }
    let parameters: Alamofire.Parameters = json
    let requestParameters = RequestParameters(method: .post,
                                              route: Route.videos(),
                                              needsAuthorization: false,
                                              parameters: parameters,
                                              parametersEncoding: URLEncoding.httpBody)
    return self.webServices.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, json: Any) -> Observable<Video> in
        return self.webServices.serializationSwiftyJSON.parse(object: json)
      })
  }
  
  func deleteVideo(identifier: Int) -> Observable<Void> {
    let requestParameters = RequestParameters(method: .delete,
                                              route: Route.video(identifier: identifier),
                                              needsAuthorization: false,
                                              parametersEncoding: URLEncoding.default)
    return self.webServices.videoNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
  
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
