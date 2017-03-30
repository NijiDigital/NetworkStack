//
//  VideoView.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 30/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation

protocol VideoView: class {
  func fetched(videos: [Video])
  func added(video: Video)
  func deleted()
  func error(message: String)
}
