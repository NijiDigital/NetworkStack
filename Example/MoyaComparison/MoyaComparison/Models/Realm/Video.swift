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
import RealmSwift
import Realm

final class Video: Object {
  
  enum Attributes {
    static let identifier = "id"
    static let title = "title"
    static let creationDate = "creationDate"
    static let likeCounts = "likeCounts"
    static let hasSponsors = "hasSponsors"
    static let statusCode = "statusCode"
  }
  
  enum Relationships {
    static let relatedVideos = "relatedVideos"
  }

  // MARK: Attributes
  @objc dynamic var identifier: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var creationDate: Date?
  @objc dynamic var likeCounts: Int = 0
  
  // Use RealmOptional as less as possible
  let hasSponsors = RealmOptional<Bool>()
  let statusCode = RealmOptional<Int>()
  
  // MARK: Relationships
  let relatedVideos = List<Video>()
  
  override static func primaryKey() -> String? {
    return "identifier"
  }
}
