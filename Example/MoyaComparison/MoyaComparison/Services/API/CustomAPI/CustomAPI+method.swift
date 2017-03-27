//
//  CustomAPI+method.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 23/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import Moya

extension CustomAPI {
  public var method: Moya.Method {
    switch self {
    case .getVideo, .getVideos:
      return .get
    case .putVideo:
      return .put
    case .postVideo, .uploadVideoDocument, .authent:
      return .post
    case .delVideo:
      return .delete
    }
  }
}
