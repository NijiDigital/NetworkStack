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
  var headers: [String : String]? {
    return [:]
  }
  
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
      return .uploadFile(fileURL)
    }
    let parameters: [String: Any]
    let encoding: ParameterEncoding
    switch self {
    case .authent(let email, let passwd):
      let stringToEncode: String = String(format: "%@:%@", email, passwd)
      parameters = ["Authorization": "Basic \(stringToEncode.convertToBase64())"]
      encoding = URLEncoding.default
    case .delVideo, .getVideo, .getVideos:
      parameters = [:]
      encoding = URLEncoding.default
    case .postVideo(let video), .putVideo(let video):
      parameters = (try? video.toJSON()) ?? [:]
      encoding = URLEncoding.httpBody
    case .uploadVideoDocument:
      parameters = [:]
      encoding = URLEncoding.httpBody
    }
    return .requestParameters(parameters: parameters, encoding: encoding)
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
