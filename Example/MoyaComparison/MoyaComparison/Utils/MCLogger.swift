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
import SwiftyBeaver

// Create global variable for logs
let logger =  SwiftyBeaver.self

struct MCLogger {
  static func setup() {
    let console = ConsoleDestination()
    
    console.format = "$D[HH:mm:ss]$d $L - $N.$F:$l > $M"
    console.levelString.verbose = "📔 -- VERBOSE"
    console.levelString.debug = "📗 -- DEBUG"
    console.levelString.info = "📘 -- INFO"
    console.levelString.warning = "📙 -- WARNING"
    console.levelString.error = "📕 -- ERROR"
    
    logger.addDestination(console)
  }
}

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
