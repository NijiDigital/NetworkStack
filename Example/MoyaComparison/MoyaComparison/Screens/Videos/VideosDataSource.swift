//
//  VideosDataSource.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 02/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import UIKit

final class VideosDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
  
  // MARK: - Private Properties
  var videos: [Video] = []
  var dataStore: VideoDataStore
  
  init(dataStore: VideoDataStore) {
    self.dataStore = dataStore
  }
  
  // MARK: - Private Constants
  fileprivate enum Dimension {
    static let heightForRow: CGFloat = 80
    static let sections: Int = 1
  }
}

// MARK: - UITableViewDelegate implementation
extension VideosDataSource {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Dimension.heightForRow
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.dataStore.deleteVideo(identifier: videos[indexPath.row].identifier)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
}

// MARK: - UITableViewDataSource implementation
extension VideosDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return videos.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return Dimension.sections
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: VideoCell = tableView.dequeueReusableCell(for: indexPath)
    if let video = self.videos[safe: indexPath.row] {
      cell.config(with: video)
    }
    return cell
  }
}
