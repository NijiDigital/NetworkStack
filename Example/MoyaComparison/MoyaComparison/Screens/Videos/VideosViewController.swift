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
  fileprivate var dataSource: VideosDataSource?
  private var webServiceClients: WebServiceClients?
  private let disposeBag = DisposeBag()
  
  // MARK: - Private Constants
  fileprivate enum Dimension {
    static let errorAlertTitle = "Erreur"
    static let errorAlertButton = "ok"
  }
  
  // MARK: - Instance
  public static func instance(webServiceClients: WebServiceClients?, dataSource: VideosDataSource) -> VideosViewController {
    let controller = VideosViewController.instantiate()
    controller.webServiceClients = webServiceClients
    controller.dataSource = dataSource
    return controller
  }
  
  // MARK: - Override Funcs
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupSubViews()
    self.dataSource?.dataStore.fetchVideos()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.refreshControl?.addTarget(self, action: #selector(VideosViewController.handleRefresh(refreshControl:)), for: .valueChanged)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  override var prefersStatusBarHidden: Bool { return false }
  
  // MARK: - User Actions
  func handleRefresh(refreshControl: UIRefreshControl) {
    self.dataSource?.dataStore.fetchVideos()
  }
  
  // MARK: - Private Funcs
  private func setupSubViews() {
    self.setupTableView()
    self.dataSource?.dataStore.delegate = self
    self.setupRightNavigationItems(image: Asset.iconPlus.image, color: Color.green) { [unowned self] in
      self.dataSource?.dataStore.addVideo()
    }
  }
  
  private func setupTableView() {
    self.tableView.delegate = dataSource
    self.tableView.dataSource = dataSource
    self.tableView.register(cellType: VideoCell.self)
  }
}

// MARK: - VideoView implementation
extension VideosViewController: VideoView {
  func fetched(videos: [Video]) {
    self.refreshControl?.endRefreshing()
    self.dataSource?.addAll(videos)
    self.tableView.reloadData()
    
  }
  
  func added(video: Video) {
    self.dataSource?.add(video)
    self.tableView.reloadData()
  }
  
  func deleted() {
    self.tableView.reloadData()
  }
  
  func error(message: String) {
    
    let alert = UIAlertController(title: Dimension.errorAlertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: Dimension.errorAlertButton, style: UIAlertActionStyle.cancel) { _ in
      self.refreshControl?.endRefreshing()
    }
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}
