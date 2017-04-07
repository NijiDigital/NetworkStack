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
