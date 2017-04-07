//
//  Video+Decodable.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 07/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import Decodable

extension Video: Decodable {
  static func decode(_ json: Any) throws -> Video {
    let video = Video()
    video.identifier = try json => KeyPath(Attributes.identifier)
    video.title = try json => KeyPath(Attributes.title)
    video.creationDate = try DateFormatter.iso8601Formatter.date(from: json => KeyPath(Attributes.creationDate))
    video.hasSponsors.value = try json => KeyPath(Attributes.hasSponsors)
    video.likeCounts = try json => KeyPath(Attributes.likeCounts)
    video.statusCode.value = try json => KeyPath(Attributes.statusCode)
    let relatedVideosSandbox: [Video] = try json => KeyPath(Relationships.relatedVideos)
    video.relatedVideos.append(objectsIn: relatedVideosSandbox)
    return video
  }
}
