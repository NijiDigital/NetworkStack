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
import Reusable
import RxSwift

final class VideosViewController: UITableViewController, StoryboardBased {
  
  // MARK: - Private Properties
  private var webservice: WebServiceClient?
  fileprivate var dataStore: VideoDataStore?
  private let disposeBag = DisposeBag()
  fileprivate var videos: [Video] = []
  
  // MARK: - Private Constants
  fileprivate enum Dimension {
    static let errorAlertTitle = "Erreur"
    static let errorAlertButton = "ok"
    static let heightForRow: CGFloat = 80
    static let sections: Int = 1
  }
  
  // MARK: - Instance
  public static func instance(webService: WebServiceClient?, dataStore: VideoDataStore) -> VideosViewController {
    let controller = VideosViewController.instantiate()
    controller.webservice = webService
    controller.dataStore = dataStore
    return controller
  }
  
  // MARK: - Override Funcs
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupSubViews()
    self.dataStore?.fetchVideos()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: .valueChanged)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  // MARK: - User Actions
  func handleRefresh(refreshControl: UIRefreshControl) {
    self.dataStore?.fetchVideos()
  }
  
  // MARK: - Private Funcs
  private func setupSubViews() {
    self.setupTableView()
    self.dataStore?.delegate = self
    self.setupRightNavigationItems(image: Asset.iconPlus.image, color: Color.green) { [unowned self] in
      self.dataStore?.addVideo()
    }
  }
  
  private func setupTableView() {
    self.tableView.register(cellType: VideoCell.self)
  }
}

// MARK: - VideoView implementation
extension VideosViewController: VideoView {
  func fetched(videos: [Video]) {
    self.videos = videos
    self.tableView.reloadData()
    self.refreshControl?.endRefreshing()
  }
  
  func added(video: Video) {
    self.videos.insert(video, at: self.videos.endIndex)
    self.tableView.reloadData()
  }
  
  func deleted() {
    self.tableView.reloadData()
  }
  
  func error(message: String) {
    let alert = UIAlertController(title: Dimension.errorAlertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: Dimension.errorAlertButton, style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDelegate implementation
extension VideosViewController {
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Dimension.heightForRow
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.dataStore?.deleteVideo(identifier: videos[indexPath.row].identifier)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
}

// MARK: - UITableViewDataSource implementation
extension VideosViewController {
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return videos.count
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return Dimension.sections
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: VideoCell = self.tableView.dequeueReusableCell(for: indexPath)
    if let video = self.videos[safe: indexPath.row] {
      cell.setup(video: video)
    }
    return cell
  }
}
