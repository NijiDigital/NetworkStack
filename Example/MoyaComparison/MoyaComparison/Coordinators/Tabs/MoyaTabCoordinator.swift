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
import UIKit

final class MoyaTabCoordinator: NavCoordinator {
  
  // MARK: - Private Properties
  var mainViewController: UIViewController
  internal var childCoordinators: [Coordinator] = []
  private let webServiceClient: WebServiceClient
  
  // MARK: - Init
  init(mainViewController: UIViewController, webServiceClient: WebServiceClient) {
    self.mainViewController = mainViewController
    self.webServiceClient = webServiceClient
    
    self.navigationController.tabBarItem = UITabBarItem(title: TabsName.moya.rawValue, image: Asset.iconMoya.image, tag: TabsTag.moya.rawValue)
    self.navigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
    self.navigationController.setupBlackNavigationBar()
    self.start()
  }
  
  // MARK: - Public Funcs
  func start() {
    self.moveToLoader()
  }
  
  func stop() {}
  
  // MARK: - Private Funcs
  private func moveToLoader() {
    let controller = LoaderViewController.instance(actions: self)
    self.pushToRoot(viewController: controller)
  }
  
  fileprivate func moveToMoyaStack() {
    let dataStore = VideoDataStore(webService: self.webServiceClient.clients.moya)
    let controller = VideosViewController.instance(webService: self.webServiceClient, dataStore: dataStore)
    self.pushToRoot(viewController: controller)
  }
}

// MARK: - LoaderViewControllerActions
extension MoyaTabCoordinator: LoaderViewControllerActions {
  func didFinishLoad() {
    self.moveToMoyaStack()
  }
}
