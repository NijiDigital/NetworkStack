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
import JSONCodable
import ObjectMapper
import SwiftyJSON

/// Swifty protocol to use Generics for parsing with SwiftyJSON
protocol Swifty {
  init(json: JSON)
  func toJSON() -> JSON
}

extension Swifty {
  public func toJSON() -> JSON {
    return JSON(self)
  }
}

/// MultipleJSONConformance protocol is conformance of JSONCodable, Mappable, Swifty protocols
protocol MultipleJSONConformance: JSONCodable, Mappable, Swifty {}

/// DualJSONConformance protocol is conformance of JSONCodable, Swifty protocols
protocol DualJSONConformance: JSONCodable, Swifty {}
