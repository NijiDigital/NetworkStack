//
//  MCLogger+LogModule.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 30/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import SwiftyBeaver

public enum LogModule: String {
  case appCoordinator
  case githubProvider
  case webServiceClient
  case parsing
  case encoding
}

extension SwiftyBeaver {
  
  public class func verbose(_ module: LogModule, _ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    verbose({ return "[\(module.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public class func debug(_ module: LogModule, _ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    debug({ return "[\(module.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public class func info(_ module: LogModule, _ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    info({ return "[\(module.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public class func warning(_ module: LogModule, _ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    warning({ return "[\(module.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public class func error(_ module: LogModule, _ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    error({ return "[\(module.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
}
