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

protocol webService {
  var webServices: WebServices { get set }
}

/// Web Service for Videos
protocol VideoWebService: webService {
  
  /// Retreive all Videos from Server
  ///
  /// - Returns: Observable of all Videos
  func fetchAllVideos() -> Observable<[Video]>
  
  /// Retreive specific video from server
  ///
  /// - Parameter video: video identifier to retreive
  /// - Returns: Observable of specific Video
  func fetchVideo(identifier: Int) -> Observable<Video>
  
  /// Update specific Video on server
  ///
  /// - Parameter video: video to update
  /// - Returns: Observable of Void because deleting doesn't return object
  func updateVideo(video: Video) -> Observable<Void>
  
  /// Add a video on server
  ///
  /// - Parameter identifier: video object to add
  /// - Returns: Observable of Video. Video full object from server.
  func addVideo(video: Video) -> Observable<Video>
  
  /// Delete specific video from server
  ///
  /// - Parameter identifier: video identifier
  /// - Returns: Observable of Void because deleting doesn't return object
  func deleteVideo(identifier: Int) -> Observable<Void>
  
  /// Create fake video for Moya service stack
  ///
  /// - Returns: fake created video
  func fakeVideoToAdd() -> Video
}
