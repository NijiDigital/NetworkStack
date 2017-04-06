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
import RxSwift
import Moya

struct MoyaVideoWebService: VideoWebServiceClient {
  var services: Services
  
  func fetchAllVideos() -> Observable<[Video]> {
    return self.services.customAPIProvider.request(CustomAPI.getVideos()).mapJSON()
      .flatMap({ (json: Any) -> Observable<[Video]> in
        return self.services.serializationSwiftyJSON.parse(objects: json)
      })
  }
  
  func fetchVideo(identifier: Int) -> Observable<Video> {
    return self.services.customAPIProvider.request(CustomAPI.getVideo(identifier: identifier)).mapJSON()
      .flatMap({ (json: Any) -> Observable<Video> in
        return self.services.serializationSwiftyJSON.parse(object: json)
      })
  }
  
  func update(video: Video) -> Observable<Void> {
    return self.services.customAPIProvider.request(CustomAPI.putVideo(video: video)).asObservable()
      .flatMap({ _ -> Observable<Void> in
        return Observable.empty()
      })
  }
  
  func add(video: Video) -> Observable<Video> {
    return self.services.customAPIProvider.request(CustomAPI.postVideo(video: video)).mapJSON()
      .flatMap({ (json: Any) -> Observable<Video> in
        return self.services.serializationSwiftyJSON.parse(object: json)
      })
  }
  
  func deleteVideo(identifier: Int) -> Observable<Void> {
    return self.services.customAPIProvider.request(CustomAPI.delVideo(identifier: identifier)).asObservable()
      .flatMap({ _ -> Observable<Void> in
        return Observable.empty()
      })
  }
  
  func fakeVideoToAdd() -> Video {
    let video = Video()
    video.title = "Moya network stack"
    video.creationDate = Date()
    video.hasSponsors.value = true
    video.likeCounts = 10000
    video.statusCode.value = 10
    return video
  }
}
