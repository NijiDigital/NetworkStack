//
//  CustomAPI+path.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 23/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation

extension CustomAPI {
  public var path: String {
    switch self {
    case .authent:
      return "/authent"
    case .getVideos:
      return "/videos"
    case .getVideo(let identifier):
      return "/videos/\(identifier)"
    case .putVideo(let identifier):
      return "/videos/\(identifier)"
    case .postVideo(let identifier):
      return "/videos/\(identifier)"
    case .delVideo(let identifier):
      return "/videos/\(identifier)"
    case .uploadVideoDocument(let identifier):
      return "/videos/\(identifier)/document"
    }
  }
}
