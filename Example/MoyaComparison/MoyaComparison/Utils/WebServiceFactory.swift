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
import NetworkStack
import Moya

struct WebServiceFactory {
  static func clients() -> WebServiceClients {
    let services: Services = self.services()
    let clients = WebServiceClients(
      niji: NijiVideoWebServiceClient(services: services),
      moya: MoyaVideoWebServiceClient(services: services),
      user: UserWebServicesClient(services: services),
      authent: AuthenticationWebServiceClient(services: services)
    )
    return clients
  }
  
  static func services() -> Services {
    let userBaseURL: String = Environment.baseURL + Environment.apiVersion
    let videoBaseURL: String = Environment.baseURL + Environment.apiVersion
    let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.example.moyacomparison.keychain")
    let userNetworkStack = NetworkStack(baseURL: userBaseURL, keychainService: keychainService)
    let videoNetworkStack = NetworkStack(baseURL: videoBaseURL, keychainService: keychainService)
    let customAPIProvider = RxMoyaProvider<CustomAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    let webServices = Services(
      serializationJSONCodable: SerializationServiceJSONCodable(),
      serializationSwiftyJSON: SerializationServiceSwiftyJSON(),
      serializationObjectMapper: SerializationServiceObjectMapper(),
      userNetworkStack: userNetworkStack,
      videoNetworkStack: videoNetworkStack,
      customAPIProvider: customAPIProvider
    )
    return webServices
  }
}
