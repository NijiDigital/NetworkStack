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
import RxSwift
import Alamofire

struct AuthenticationWebService {
  // MARK: - Properties
  var services: Services
  
  // MARK: - Public Func
  /// Authentication method with Basic auth (user and password will be encoded like that ````base64(user:password)````) and Bearer service
  /// for all next requests that you need Authorization header. In this method you have an init about refresh token handler.
  ///
  /// - Parameters:
  ///   - user: user identifier for authentication
  ///   - password: user password for authentication
  /// - Returns: Observable of Void because network stack save into Keychain token, refreshToken and expirationDate
  func authent(user: String, password: String) -> Observable<Void> {
    
    // set refreshToken when you launch authent WS
    self.services.userNetworkStack.renewTokenHandler = {
      return self.refreshToken()
    }
    
    return self.services.userNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.authent(user: user, password: password))
      .flatMap({ (_, json: Any) -> Observable<Authorization> in
        return self.services.serializationSwiftyJSON.parse(object: json)
      })
      .map({ (authent: Authorization) -> Void in
        self.services.userNetworkStack.clearToken()
        self.services.userNetworkStack.updateToken(token: authent.token, refreshToken: authent.refreshToken, expiresIn: authent.expirationDate)
        return
      })
  }
  
  // MARK: - Private Funcs
  /// This private func is used to refresh token by NetworkStack. This method is called above, inside renewTokenHandler: computed property
  ///
  /// - Returns: Observable of Void because network stack handle token and refreshToken update
  private func refreshToken() -> Observable<Void> {
    guard let refreshToken = self.services.userNetworkStack.currentRefreshToken() else {
      return Observable.error(WebServiceError.missingMandatoryValue(valueInfo: "refreshToken"))
    }
    
    return self.services.userNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.refreshToken(refreshToken))
      .flatMap({ (_, json: Any) -> Observable<Authorization> in
        return self.services.serializationSwiftyJSON.parse(object: json)
      })
      .map({ (authent: Authorization) -> Void in
        self.services.userNetworkStack.clearToken()
        self.services.userNetworkStack.updateToken(token: authent.token, refreshToken: authent.refreshToken, expiresIn: authent.expirationDate)
        return
      })
  }
}
