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

extension Video {
  
  // MARK: Initializers
  convenience init?(map: Map) {
    self.init()
  }
  
  // MARK: Mappable
  func mapping(map: Map) {
    // Attributes
    self.identifier <- map[Attributes.identifier.rawValue]
    self.title <- map[Attributes.title.rawValue]
    self.creationDate <- (map[Attributes.creationDate.rawValue], ISO8601DateTransform())
    self.likeCounts <- map[Attributes.likeCounts.rawValue]
    self.hasSponsors.value <- map[Attributes.hasSponsors.rawValue]
    self.statusCode.value <- map[Attributes.statusCode.rawValue]
    // Relationships
    var relatedVideosSandbox: [Video] = []
    relatedVideosSandbox <- map[Video.Relationships.relatedVideos.rawValue]
    self.relatedVideos.append(objectsIn: relatedVideosSandbox)
  }
}
