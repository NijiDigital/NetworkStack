//
//  CustomAPI.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 18/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import Moya

// MARK: - Provider setup
public enum CustomAPI: TargetType {
  case authent(email: String, passwd: String)
  case getVideos()
  case getVideo(identifier: String)
  case putVideo(identifier: String)
  case postVideo(identifier: String)
  case delVideo(identifier: String)
  case uploadVideoDocument(identifier: String)
}

extension CustomAPI {
  public var baseURL: URL {
    guard let url = URL(string: Environment.baseURL + Environment.apiVersion) else {
      logger.error(.githubProvider, "Failed to manage data")
      fatalError("Failed to convert base url string to URL ! -- CustomProvider")
    }
    return url
  }
}

extension CustomAPI {
  public var task: Task {
    if case .uploadVideoDocument(let identifier) = self {
      let fileURL: URL = URL(string: "\(identifier)")!
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
