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
import Decodable
import RxSwift

struct SerializationServiceDecodable {
  
  // MARK: parse func
  func parse<T: Decodable>(object: Any) throws -> T {
    return try T.decode(json: object)
  }
  
  func parse<T: Decodable>(objects: Any) throws -> [T] {
    var objectList = [T]()
    let objectsToDeserialize: [Any]
    if let objects = objects as? [Any] {
      objectsToDeserialize = objects
    } else {
      objectsToDeserialize = [objects]
    }
    do {
      objectList = try objectsToDeserialize.flatMap { (json: Any) -> T in
          return try T.decode(json: json)
        }
    } catch {
      throw SerializationServiceError.unexpectedFormat(json: "Failed to parse json : \(objects) to \(T.self)")
    }
    return objectList
  }
  
  func parse<T: Decodable>(objects: Any) -> Observable<[T]> {
    return Observable.create({ observer in
      do {
        let results: [T] = try self.parse(objects: objects)
        observer.on(.next(results))
        observer.on(.completed)
      } catch {
        observer.on(.error(error))
      }
      return Disposables.create()
    })
  }
  
  func parse<T: Decodable>(object: Any) -> Observable<T> {
    return Observable.create { observer in
      do {
        let result: T = try self.parse(object: object)
        observer.on(.next(result))
        observer.on(.completed)
      } catch {
        observer.on(.error(error))
      }
      return Disposables.create()
    }
  }
}
