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

extension LogModule {
  public func verbose(_ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    SwiftyBeaver.verbose({ return "[\(self.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public func debug(_ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    SwiftyBeaver.debug({ return "[\(self.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public func info(_ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    SwiftyBeaver.info({ return "[\(self.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public func warning(_ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    SwiftyBeaver.warning({ return "[\(self.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
  
  public func error(_ message: @autoclosure @escaping () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
    SwiftyBeaver.error({ return "[\(self.rawValue)] - \(message())" as Any}(), path, function, line: line)
  }
}
