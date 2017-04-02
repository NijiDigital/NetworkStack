//
//  WebServiceFactory.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 02/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import NetworkStack
import Moya

struct WebServiceFactory {
  static func clients() -> ServiceClients {
    let clients = ServiceClients(
      niji: NijiVideoWebService(webServices: webServices()),
      moya: MoyaVideoWebService(webServices: webServices()),
      user: UserWebServices(webServices: webServices()),
      authent: AuthenticationWebService(webServices: webServices())
    )
    return clients
  }
  
  static func webServices() -> WebServices {
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
    return webServices
  }
}
