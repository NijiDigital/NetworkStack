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
import Moya

// MARK: - Provider setup
enum CustomAPI: TargetType {
  case authent(email: String, passwd: String)
  case getVideos()
  case getVideo(identifier: Int)
  case putVideo(video: Video)
  case postVideo(video: Video)
  case delVideo(identifier: Int)
  case uploadVideoDocument(identifier: Int, fileURL: URL)
}

extension CustomAPI {
  public var baseURL: URL {
    guard let url = URL(string: Environment.baseURL + Environment.apiVersion) else {
      LogModule.githubProvider.error("Failed to manage data")
      fatalError("Failed to convert base url string to URL ! -- CustomProvider")
    }
    return url
  }
}

extension CustomAPI {
  public var task: Task {
    if case .uploadVideoDocument(_, let fileURL) = self {
      let uploadType = UploadType.file(fileURL)
      return .upload(uploadType)
    }
    return .request
  }
}

extension CustomAPI {
  public var validate: Bool {
    return true
  }
}

extension CustomAPI {
  public var sampleData: Data {
    return Data()
  }
}
