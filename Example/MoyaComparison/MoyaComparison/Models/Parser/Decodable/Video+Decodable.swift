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

import Decodable

extension Video: Decodable {
  static func decode(_ json: Any) throws -> Video {
    let video = Video()
    video.identifier = try json => KeyPath(Attributes.identifier)
    video.title = try json => KeyPath(Attributes.title)
    video.creationDate = try DateFormatter.iso8601Formatter.date(from: json => KeyPath(Attributes.creationDate))
    video.hasSponsors.value = try json => KeyPath(Attributes.hasSponsors)
    video.likeCounts = try json => KeyPath(Attributes.likeCounts)
    video.statusCode.value = Int(try json => KeyPath(Attributes.statusCode))
    let relatedVideosSandbox: [Video]? = try json =>? "relatedVideos"
    if let relatedVideosSandbox = relatedVideosSandbox {
      video.relatedVideos.append(objectsIn: relatedVideosSandbox)
    }
    return video
  }
}
