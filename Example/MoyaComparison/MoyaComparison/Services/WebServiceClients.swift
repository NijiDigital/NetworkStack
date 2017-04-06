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
import Moya

/// WebServices is a struct to centralize serialization and network stack
struct Services {
  let serializationJSONCodable: SerializationServiceJSONCodable
  let serializationSwiftyJSON: SerializationServiceSwiftyJSON
  let serializationObjectMapper: SerializationServiceObjectMapper
  let userNetworkStack: NetworkStack
  let videoNetworkStack: NetworkStack
  let customAPIProvider: RxMoyaProvider<CustomAPI>
}

/// ServiceClients is a struct to centralize web services client split in several structs
struct WebServiceClients {
  let niji: NijiVideoWebService
  let moya: MoyaVideoWebService
  let user: UserWebServices
  let authent: AuthenticationWebService
}
