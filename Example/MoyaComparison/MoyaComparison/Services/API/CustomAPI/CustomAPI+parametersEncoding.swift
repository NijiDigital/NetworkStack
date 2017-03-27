//
//  CustomAPI+parametersEncoding.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 23/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import Moya

extension CustomAPI {
  public var parameterEncoding: ParameterEncoding {
    switch self {
    case .authent, .delVideo, .getVideo, .getVideos:
      return URLEncoding.default
    case .putVideo, .postVideo, .uploadVideoDocument:
      return URLEncoding.httpBody
    }
  }
}
