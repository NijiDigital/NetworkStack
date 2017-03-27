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
import RxSwift
import Alamofire
import NetworkStack

extension WebServiceClient {
  func fetchAllUsers() -> Observable<[User]> {
    let requestParameters = RequestParameters(method: .get,
                                              route: Route.users(),
                                              needsAuthorization: false,
                                              parametersEncoding: URLEncoding.default)
    
    return self.webServices.userNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, json: Any) -> Observable<[User]> in
        return self.webServices.serializationSwiftyJSON.parse(objects: json)
      })
  }
  
  func fetchUser(identifier: Int) -> Observable<User> {
    let requestParameters = RequestParameters(method: .get,
                                              route: Route.user(identifier: identifier),
                                              needsAuthorization: false,
                                              parametersEncoding: URLEncoding.default)
    return self.webServices.userNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, json: Any) -> Observable<User> in
        return self.webServices.serializationSwiftyJSON.parse(object: json)
      })
  }
  
  func updateUser(_ user: User) -> Observable<Void> {
    guard let json: JSONObject = user.toJSON().dictionaryObject else {
      let error = SerializationServiceError.unexpectedParsing(object: user)
      logger.error(.webServiceClient, "Failed to parse user : \(error)")
      return Observable.error(error)
    }
    let parameters: Alamofire.Parameters = json
    let requestParameters = RequestParameters(method: .put,
                                              route: Route.user(identifier: user.identifier),
                                              needsAuthorization: false,
                                              parameters: parameters,
                                              parametersEncoding: URLEncoding.httpBody)
    return self.webServices.userNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
  
  func addUser(_ user: User) -> Observable<Void> {
    guard let json: JSONObject = user.toJSON().dictionaryObject else {
      let error = SerializationServiceError.unexpectedParsing(object: user)
      logger.error(.webServiceClient, "Failed to parse user : \(error)")
      return Observable.error(error)
    }
    let parameters: Alamofire.Parameters = json
    let requestParameters = RequestParameters(method: .delete,
                                              route: Route.users(),
                                              needsAuthorization: false,
                                              parameters: parameters,
                                              parametersEncoding: URLEncoding.httpBody)
    return self.webServices.userNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
  
  func deleteUser(identifier: Int) -> Observable<Void> {
    
    let requestParameters = RequestParameters(method: .post,
                                              route: Route.user(identifier: identifier),
                                              needsAuthorization: false,
                                              parametersEncoding: URLEncoding.default)
    return self.webServices.userNetworkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .flatMap({ (_, _) -> Observable<Void> in
        return Observable.empty()
      })
  }
  
}
