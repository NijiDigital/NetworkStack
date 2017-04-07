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

enum TabsName: String {
  case niji = "Niji"
  case moya = "Moya"
}

enum TabsTag: Int {
  case niji = 1
  case moya
}

final class TabsCoordinator: TabCoordinator {
  
  // MARK: - Private Properties
  var mainViewController: UIViewController
  internal var childCoordinators: [Coordinator] = []
  private let webServiceClients: WebServiceClients
  
  private struct TabsCoordinators {
    let niji: NijiTabCoordinator
    let moya: MoyaTabCoordinator
    func all() -> [NavCoordinator] { return [niji, moya] }
  }
  
  private lazy var coordinators: TabsCoordinators = TabsCoordinators(
    niji: NijiTabCoordinator(mainViewController: UINavigationController(), webServiceClients: self.webServiceClients),
    moya: MoyaTabCoordinator(mainViewController: UINavigationController(), webServiceClients: self.webServiceClients)
  )
  
  // MARK: - Init
  init(mainViewController: UIViewController, webServiceClients: WebServiceClients) {
    self.mainViewController = mainViewController
    self.webServiceClients = webServiceClients
  }
  
  // MARK: - Public Funcs
  func start() {
    self.tabBarController.viewControllers = coordinators.all().map({ $0.navigationController })
    self.tabBarController.tabBar.setupBlackTabBar()
  }
}
