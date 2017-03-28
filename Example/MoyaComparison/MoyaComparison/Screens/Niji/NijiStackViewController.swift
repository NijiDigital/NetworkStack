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

final class NijiStackViewController: UIViewController, StoryboardBased {
  
  // MARK: - Private Properties
  private var webservice: WebServiceClient?
  fileprivate var dataStore: VideoDataStore?
  private let disposeBag = DisposeBag()
  fileprivate var videos: [Video] = []
  
  // MARK: - Private Outlets
  @IBOutlet fileprivate weak var tableView: UITableView!
  
  // MARK: - Private Constants
  fileprivate enum Dimension {
    static let errorAlertTitle = "Erreur"
    static let errorAlertButton = "ok"
    static let heightForRow: CGFloat = 80
    static let sections: Int = 1
  }
  
  // MARK: - Instance
  public static func instance(webService: WebServiceClient?, dataStore: VideoDataStore) -> NijiStackViewController {
    let controller = NijiStackViewController.instantiate()
    controller.webservice = webService
    controller.dataStore = dataStore
    return controller
  }
  
  // MARK: - Override Funcs
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupSubViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.dataStore?.fetchVideos()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  // MARK: - Private Funcs
  private func setupSubViews() {
    self.setupTableView()
    self.dataStore?.delegate = self
    self.setupRightNavigationItems(image: Asset.iconPlus.image, title: "", color: Color.black) { [unowned self] in
      self.dataStore?.addVideo()
    }
  }
  
  private func setupTableView() {
    self.tableView.register(cellType: VideoCell.self)
  }
}

extension NijiStackViewController: VideoDataStoreDelegate {
  func fetched(videos: [Video]) {
    self.videos = videos
    self.tableView.reloadData()
  }
  
  func added(video: Video) {
    self.videos.insert(video, at: 0)
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

extension NijiStackViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Dimension.heightForRow
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.dataStore?.deleteVideo(identifier: videos[indexPath.row].identifier)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
}

extension NijiStackViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return videos.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return Dimension.sections
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: VideoCell = self.tableView.dequeueReusableCell(for: indexPath)
    cell.setup(video: self.videos[indexPath.row])
    return cell
  }
}