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
  var webServices: WebServices
  func authent(user: String, password: String) -> Observable<Void> {
    
    return self.webServices.userNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.authent(user: user, password: password))
      .flatMap({ (_, json: Any) -> Observable<Authorization> in
        return self.webServices.serializationSwiftyJSON.parse(object: json)
      })
      .map({ (authent: Authorization) -> Void in
        self.webServices.userNetworkStack.clearToken()
        self.webServices.userNetworkStack.updateToken(token: authent.token, refreshToken: authent.refreshToken, expiresIn: authent.expirationDate)
        return
      })
  }
  
  func refreshToken() -> Observable<Void> {
    guard let refreshToken = self.webServices.userNetworkStack.currentRefreshToken() else {
      return Observable.error(WebServiceError.missingMandatoryValue(valueInfo: "refreshToken"))
    }
    
    return self.webServices.userNetworkStack.sendRequestWithJSONResponse(requestParameters: RequestParameters.refreshToken(refreshToken))
      .flatMap({ (_, json: Any) -> Observable<Authorization> in
        return self.webServices.serializationSwiftyJSON.parse(object: json)
      })
      .map({ (authent: Authorization) -> Void in
        self.webServices.userNetworkStack.clearToken()
        self.webServices.userNetworkStack.updateToken(token: authent.token, refreshToken: authent.refreshToken, expiresIn: authent.expirationDate)
        return
      })
  }
}
