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
import NetworkStack
import Moya

final class AppCoordinator: Coordinator {
  
  // MARK: - Private Properties
  var mainViewController: UIViewController
  private var webServicesContainer: WebServicesContainer?
  internal var childCoordinators: [Coordinator] = []
  
  // MARK: - Init
  init(mainViewController: UIViewController) {
    self.mainViewController = mainViewController
    self.initWebServiceClient()
  }
  
  // MARK: - Public Funcs
  func start() {
    self.startTabBar()
  }
  
  // MARK: - Private Funcs
  private func initWebServiceClient() {
    let clients = WebServiceFactory.clients()
    self.webServicesContainer = WebServicesContainer(clients: clients)
  }
  
  fileprivate func startTabBar() {
    if let webServicesContainer = self.webServicesContainer {
      let coordinator = TabsCoordinator(mainViewController: self.mainViewController, webServicesContainer: webServicesContainer)
      self.childCoordinators.append(coordinator)
      coordinator.start()
    }
  }
}
