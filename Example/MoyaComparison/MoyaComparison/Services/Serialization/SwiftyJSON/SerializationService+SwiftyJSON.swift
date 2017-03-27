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
import SwiftyJSON
import RxSwift

// MARK: serialization to convert object to JSONDict or parse JSONDict to object
struct SerializationServiceSwiftyJSON {
  
  // MARK: Parse funcs
  func parse<T: Swifty>(object: Any) -> T {
    let json = JSON(object)
    return T.init(json: json)
  }
  
  func parse<T: Swifty>(objects: Any) -> [T] {
    let json = JSON(objects)
    return json.map { (_, json: JSON) -> T in
      return T.init(json: json)
    }
  }
  
  func parse<T: Swifty>(object: Any) -> Observable<T> {
    return Observable.create({ (observer: AnyObserver<T>) -> Disposable in
      let result: T = self.parse(object: object)
      observer.on(.next(result))
      observer.on(.completed)
      return Disposables.create()
    })
  }
  
  func parse<T: Swifty>(objects: Any) -> Observable<[T]> {
    return Observable.create({ (observer: AnyObserver<[T]>) -> Disposable in
      let results: [T] = self.parse(objects: objects)
      observer.on(.next(results))
      observer.on(.completed)
      return Disposables.create()
    })
  }
}
