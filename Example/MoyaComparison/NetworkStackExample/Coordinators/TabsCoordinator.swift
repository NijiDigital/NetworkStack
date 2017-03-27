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

final class TabsCoordinator: Coordinator {
  
  // MARK: private properties
  internal var baseViewController: BaseViewController
  internal var navigationController = UINavigationController()
  internal var childCoordinators: [Coordinator] = []
  private var tabBarController = UITabBarController()
  private let webServiceClient: WebServiceClient
  
  private struct TabsCoordinators {
    let niji: NijiTabCoordinator
    let moya: MoyaTabCoordinator
//    let third: ThirdTabCoordinator
//    let forth: ForthTabCoordinator
    func all() -> [Coordinator] { return [niji, moya /*, third, forth*/] }
  }
  
  private lazy var coordinators: TabsCoordinators = TabsCoordinators(
    niji: NijiTabCoordinator(webServiceClient: self.webServiceClient),
    moya: MoyaTabCoordinator(webServiceClient: self.webServiceClient)
//    third: ThirdTabCoordinator(webServiceClient: self.webServiceClient),
//    forth: ForthTabCoordinator(webServiceClient: self.webServiceClient)
  )
  
  // MARK: init
  init(baseController: BaseViewController, webServiceClient: WebServiceClient) {
    self.baseViewController = baseController
    self.webServiceClient = webServiceClient
  }
  
  func start() {
    self.tabBarController.viewControllers = coordinators.all().map({ $0.navigationController })
    self.tabBarController.tabBar.setupBlackTabBar()
    self.baseViewController.addViewController(self.tabBarController, method: .replaceRoot)
  }
  
  func stop() {} 
}