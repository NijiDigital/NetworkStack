//
//  RequestParameters+Video.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 28/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import NetworkStack
import Alamofire

extension RequestParameters {
  public static func fetchAllVideos() -> RequestParameters {
    return RequestParameters(method: .get,
                             route: Route.videos())
  }
  
  public static func fetchVideo(identifier: Int) -> RequestParameters {
    return RequestParameters(method: .get,
                             route: Route.video(identifier: identifier))
  }
  
  public static func updateVideo(identifier: Int, parameters: Alamofire.Parameters) -> RequestParameters {
    return RequestParameters(method: .put,
                             route: Route.video(identifier: identifier),
                             parameters: parameters,
                             parametersEncoding: URLEncoding.httpBody)
  }
  
  public static func addVideo(parameters: Alamofire.Parameters) -> RequestParameters {
    return RequestParameters(method: .post,
                             route: Route.videos(),
                             parameters: parameters,
                             parametersEncoding: URLEncoding.httpBody)
  }
  
  public static func deleteVideo(identifier: Int) -> RequestParameters {
    return RequestParameters(method: .delete,
                             route: Route.video(identifier: identifier))
  }
}
