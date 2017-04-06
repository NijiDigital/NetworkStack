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

extension Video: ImmutableMappable {
  
  // MARK: Mappable
  func mapping(map: Map) {
    // Attributes
    self.identifier >>> map[Attributes.identifier]
    self.title >>> map[Attributes.title]
    self.creationDate >>> (map[Attributes.creationDate], ISO8601DateTransform())
    self.likeCounts >>> map[Attributes.likeCounts]
    self.hasSponsors.value >>> map[Attributes.hasSponsors]
    self.statusCode.value >>> map[Attributes.statusCode]
    // Relationships
    let relatedVideosSandbox: [Video] = Array(self.relatedVideos)
    relatedVideosSandbox >>> map[Video.Relationships.relatedVideos]
  }
  
  convenience init(map: Map) throws {
      self.init()
    self.identifier = try map.value(Attributes.identifier)
    self.title = try map.value(Attributes.title)
    
    self.creationDate = try map.value(Attributes.creationDate, using: ISO8601DateTransform())
    self.likeCounts = try map.value(Attributes.likeCounts)
    self.hasSponsors.value = try map.value(Attributes.hasSponsors)
    self.statusCode.value = try map.value(Attributes.statusCode)
    // Relationships
    var relatedVideosSandbox: [Video] = []
    relatedVideosSandbox = try map.value(Video.Relationships.relatedVideos)
    self.relatedVideos.append(objectsIn: relatedVideosSandbox)
  }
}
