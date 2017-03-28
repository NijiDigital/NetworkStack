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

protocol VideoDataStoreDelegate: class {
  func fetched(videos: [Video])
  func added(video: Video)
  func deleted()
  func error(message: String)
}

struct VideoDataStore {
  
  weak var delegate: VideoDataStoreDelegate?
  
  private var disposeBag = DisposeBag()
  private var webService: VideoWebService?
  
  init(webService: VideoWebService?) {
    self.webService = webService
  }
  
  func fakeNijiVideoToAdd() -> Video {
    let video = Video()
    video.title = "Moya NetworkStack"
    video.creationDate = Date()
    video.hasSponsors.value = true
    video.likeCounts = 10000
    video.statusCode.value = 10
    return video
  }
  
  func fetchVideos() {
    self.webService?.fetchAllVideos()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
      .do(
        onNext: { (videos: [Video]) in
          self.delegate?.fetched(videos: videos)
          logger.debug(.webServiceClient, "received videos : \(videos)")
      },
        onError: { (error: Error) in
          let message = "Failed to fetch videos with error : \(error)"
          self.delegate?.error(message: message)
          logger.error(.webServiceClient, message)
      }, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
      .subscribe()
      .addDisposableTo(self.disposeBag)
  }
  
  func addVideo() {
    let video = fakeNijiVideoToAdd()
    self.webService?.addVideo(video: video)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
      .do(onNext: { (video: Video) in
        self.delegate?.added(video: video)
      }, onError: { (error: Error) in
        let message = "Failed to add video with error : \(error)"
        self.delegate?.error(message: message)
        logger.error(.webServiceClient, message)
      }, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
      .subscribe()
      .addDisposableTo(self.disposeBag)
  }
  
  func deleteVideo(identifier: Int) {
    self.webService?.deleteVideo(identifier: identifier)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
      .do(onNext: nil, onError: { (error: Error) in
        let message = "Failed to delete video with error : \(error)"
        self.delegate?.error(message: message)
        logger.error(.webServiceClient, message)
      }, onCompleted: { _ in
        self.delegate?.deleted()
      }, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
      .subscribe()
      .addDisposableTo(self.disposeBag)
  }
}
