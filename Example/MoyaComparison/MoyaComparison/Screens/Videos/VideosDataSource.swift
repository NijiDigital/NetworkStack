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

import UIKit

protocol VideoProvider: class {
  func deleted()
}

final class VideosDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
  
  // MARK: - Public Properties
  var dataStore: VideoDataStore
  weak var delegate: VideoProvider?
  
  // MARK: - Private Properties
  fileprivate var videos: [Video] = []
  
  init(dataStore: VideoDataStore) {
    self.dataStore = dataStore
  }
  
  // MARK: - Public Funcs
  func addAll(_ videos: [Video]) {
    self.videos = videos
  }
  
  func add(_ video: Video) {
    self.videos.insert(video, at: self.videos.endIndex)
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
      self.dataStore.deleteVideo(identifier: videos[indexPath.row].identifier) {
        self.videos.remove(at: indexPath.row)
        self.delegate?.deleted()
      }
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
