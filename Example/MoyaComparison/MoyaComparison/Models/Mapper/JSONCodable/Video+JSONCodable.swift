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

extension Video: JSONCodable {
  
  convenience init(object: JSONObject) throws {
    self.init()
    let decoder = JSONDecoder(object: object)
    // Attributes
    self.identifier = try decoder.decode(Attributes.identifier)
    self.title = try decoder.decode(Attributes.title)
    self.creationDate = try decoder.decode(Attributes.creationDate, transformer: JSONTransformers.StringToDate)
    self.likeCounts = try decoder.decode(Attributes.likeCounts)
    self.hasSponsors.value = try decoder.decode(Attributes.hasSponsors)
    self.statusCode.value = try decoder.decode(Attributes.statusCode)
    // RelationShips
    let relatedVideosSandbox: [Video] = try decoder.decode(Relationships.relatedVideos)
    self.relatedVideos.append(objectsIn: relatedVideosSandbox)
  }
  
  func toJSON() throws -> JSONObject {
    return try JSONEncoder.create({ (encoder: JSONEncoder) in
      try encoder.encode(self.identifier, key: Attributes.identifier)
      try encoder.encode(self.title, key: Attributes.title)
      try encoder.encode(self.creationDate, key: Attributes.creationDate, transformer: JSONTransformers.StringToDate)
      try encoder.encode(self.likeCounts, key: Attributes.likeCounts)
      try encoder.encode(self.hasSponsors.value, key: Attributes.hasSponsors)
      try encoder.encode(self.statusCode.value, key: Attributes.statusCode)
      let relatedVideosSandbox: [Video] = Array(self.relatedVideos)
      try encoder.encode(relatedVideosSandbox, key: Relationships.relatedVideos)
    })
  }
}

public struct JSONTransformers {
  public static let StringToDate = JSONTransformer<String, Date?>(
    decoding: {DateFormatter.iso8601Formatter.date(from: $0)},
    encoding: {DateFormatter.iso8601Formatter.string(from: $0 ?? Date())})
}
