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
  private var webServiceClient: WebServiceClient?
  internal var baseViewController: BaseViewController // TODO: remove baseViewController -- useless for this example, keep it simple.
  internal var navigationController = UINavigationController()
  internal var childCoordinators: [Coordinator] = []
  
  // MARK: - Init
  init(baseController: BaseViewController) {
    self.baseViewController = baseController
    self.initWebServiceClient()
  }
  
  // MARK: - Public Funcs
  func start() {
    self.startTabBar()
  }
  
  // MARK: - Private Funcs
  private func initWebServiceClient() {
    let userBaseURL: String = Environment.baseURL + Environment.apiVersion
    let videoBaseURL: String = Environment.baseURL + Environment.apiVersion
    let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.example.moyacomparison.keychain")
    let userNetworkStack = NetworkStack(baseURL: userBaseURL, keychainService: keychainService)
    let videoNetworkStack = NetworkStack(baseURL: videoBaseURL, keychainService: keychainService)
    let customAPIProvider = RxMoyaProvider<CustomAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    let webServices = WebServices(
      serializationJSONCodable: SerializationServiceJSONCodable(),
      serializationSwiftyJSON: SerializationServiceSwiftyJSON(),
      serializationObjectMapper: SerializationServiceObjectMapper(),
      userNetworkStack: userNetworkStack,
      videoNetworkStack: videoNetworkStack,
      customAPIProvider: customAPIProvider
    )
    
    let clients = ServiceClients(
      niji: NijiVideoWebService(webServices: webServices),
      moya: MoyaVideoWebService(webServices: webServices),
      user: UserWebServices(webServices: webServices),
      authent: AuthenticationWebService(webServices: webServices)
    )
    
    self.webServiceClient = WebServiceClient(clients: clients)
  }
  
  fileprivate func startTabBar() {
    if let webServiceClient = self.webServiceClient {
      let coordinator = TabsCoordinator(baseController: self.baseViewController, webServiceClient: webServiceClient)
      self.childCoordinators.append(coordinator)
      coordinator.start()
    }
  }
}
