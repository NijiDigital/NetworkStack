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
import ObjectMapper

extension User {
  
  mutating func mapping(map: Map) {
    self.identifier >>> map[JSONKeys.identifier.rawValue]
    self.firstName >>> map[JSONKeys.firstName.rawValue]
    self.lastName >>> map[JSONKeys.lastName.rawValue]
    self.age >>> map[JSONKeys.age.rawValue]
  }
  
  init(map: Map) throws {
    self.identifier = try map.value(JSONKeys.identifier.rawValue)
    self.firstName = try map.value(JSONKeys.firstName.rawValue)
    self.lastName = try map.value(JSONKeys.lastName.rawValue)
    self.age = try map.value(JSONKeys.age.rawValue)
  }
}
