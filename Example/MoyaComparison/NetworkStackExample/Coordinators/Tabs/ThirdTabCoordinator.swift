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

final class ThirdTabCoordinator: Coordinator {
  
  // MARK: private properties
  internal var baseViewController = BaseViewController()
  internal var navigationController = UINavigationController()
  internal var childCoordinators: [Coordinator] = []
  private let webServiceClient: WebServiceClient
  
  // MARK: init
  init(webServiceClient: WebServiceClient) {
    self.webServiceClient = webServiceClient
    self.baseViewController.tabBarItem = UITabBarItem(title: "Third", image: nil, tag: 3)
    self.baseViewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
    start()
  }
  
  func start() {
    self.moveToLoader()
  }
  
  func stop() {}
  
  // MARK: private funcs
  private func moveToLoader() {
    let controller = LoaderViewController.instance(actions: self)
    self.baseViewController.addViewController(controller, method: .replaceRoot)
  }

  fileprivate func moveToThird() {
    let controller = ThirdViewController.instance(webService: self.webServiceClient)
    self.baseViewController.addViewController(controller, method: .replaceRoot)
  }
}

extension ThirdTabCoordinator: LoaderViewControllerActions {
  func didFinishLoad() {
    self.moveToThird()
  }
}