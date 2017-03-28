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

extension Video {
  
  convenience init(object: JSONObject) throws {
    self.init()
    let decoder = JSONDecoder(object: object)
    // Attributes
    self.identifier = try decoder.decode(Attributes.identifier.rawValue)
    self.title = try decoder.decode(Attributes.title.rawValue)
    self.creationDate = try decoder.decode(Attributes.creationDate.rawValue, transformer: JSONTransformers.StringToDate)
    self.likeCounts = try decoder.decode(Attributes.likeCounts.rawValue)
    self.hasSponsors.value = try decoder.decode(Attributes.hasSponsors.rawValue)
    self.statusCode.value = try decoder.decode(Attributes.statusCode.rawValue)
    // RelationShips
    let relatedVideosSandbox: [Video] = try decoder.decode(Relationships.relatedVideos.rawValue)
    self.relatedVideos.append(objectsIn: relatedVideosSandbox)
  }
  
  func toJSON() throws -> Any {
    return try JSONEncoder.create({ (encoder: JSONEncoder) in
      try encoder.encode(self.identifier, key: Attributes.identifier.rawValue)
      try encoder.encode(self.title, key: Attributes.title.rawValue)
      try encoder.encode(self.creationDate, key: Attributes.creationDate.rawValue, transformer: JSONTransformers.StringToDate)
      try encoder.encode(self.likeCounts, key: Attributes.likeCounts.rawValue)
      try encoder.encode(self.hasSponsors.value, key: Attributes.hasSponsors.rawValue)
      try encoder.encode(self.statusCode.value, key: Attributes.statusCode.rawValue)
      let relatedVideosSandbox: [Video] = Array(self.relatedVideos)
      try encoder.encode(relatedVideosSandbox, key: Relationships.relatedVideos.rawValue)
    })
  }
}

public struct JSONTransformers {
  public static let StringToDate = JSONTransformer<String, Date?>(
    decoding: {DateFormatter.iso8601Formatter.date(from: $0)},
    encoding: {DateFormatter.iso8601Formatter.string(from: $0 ?? Date())})
}
