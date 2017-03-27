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
import SwiftyJSON

extension Video {
  
  convenience init(json: JSON) {
    self.init()
    self.identifier = json[Attributes.identifier.rawValue].intValue
    self.title = json[Attributes.title.rawValue].stringValue
    self.creationDate = json[Attributes.creationDate.rawValue].flatMap(SwiftyTransformer.dateTransform).first
    self.likeCounts  = json[Attributes.likeCounts.rawValue].intValue
    self.hasSponsors.value = json[Attributes.hasSponsors.rawValue].boolValue
    self.statusCode.value = json[Attributes.statusCode.rawValue].intValue
    // RelationShips
    let relatedVideosSandbox: [Video] = json[Relationships.relatedVideos.rawValue].arrayValue.map(SwiftyTransformer.arrayVideoTransform)
    self.relatedVideos.append(objectsIn: relatedVideosSandbox)
  }
    
  func toJSON() -> JSON {
    var json: JSON = JSON(dictionaryLiteral: [])
    json[Attributes.identifier.rawValue].int = self.identifier
    json[Attributes.title.rawValue].string = self.title
    json[Attributes.creationDate.rawValue].string = self.creationDate.map(SwiftyTransformer.dateTransform)
    json[Attributes.likeCounts.rawValue].int = self.likeCounts
    json[Attributes.hasSponsors.rawValue].bool = self.hasSponsors.value
    json[Attributes.statusCode.rawValue].int = self.statusCode.value
    // RelationShips
    json[Relationships.relatedVideos.rawValue].arrayObject = self.relatedVideos.map(SwiftyTransformer.arrayVideoTransform)
    return json
  }
}

struct SwiftyTransformer {
  static func dateTransform(value: String, json: JSON) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter.date(from: value)
  }
  
  static func dateTransform(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter.string(from: date)
  }
  
  static func arrayVideoTransform<T: Swifty>(json: JSON) -> T {
    return T.init(json: json)
  }
  
  static func arrayVideoTransform<T: Swifty>(object: T) -> JSON {
    return object.toJSON()
  }
}
