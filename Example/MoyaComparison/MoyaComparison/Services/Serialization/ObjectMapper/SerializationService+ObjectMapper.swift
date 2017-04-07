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
import ObjectMapper
import RxSwift

struct SerializationServiceObjectMapper {
  
  // MARK: json func
  func toJSON<T: ImmutableMappable>(object: T) -> JSONObject {
    let mapper = Mapper<T>()
    return mapper.toJSON(object) as JSONObject
  }
  
  func toJSON<T: ImmutableMappable>(objects: [T]) -> JSONArray {
    let mapper = Mapper<T>()
    return mapper.toJSONArray(objects) as JSONArray
  }
  
  // MARK: Parse funcs
  func parse<T: ImmutableMappable>(object: Any) throws -> T {
    let parsedResult: T
    do {
      parsedResult = try Mapper<T>().map(JSONObject: object)
    } catch {
      throw SerializationServiceError.unexpectedFormat(json: "Failed to parse json : \(object) to \(T.self) with error : \(error)")
    }
    return parsedResult
  }
  
  func parse<T: ImmutableMappable>(objects: Any) throws -> [T] {
    let parsedResult: [T]
    do {
      parsedResult = try Mapper<T>().mapArray(JSONObject: objects)
    } catch {
      throw SerializationServiceError.unexpectedFormat(json: "Failed to parse json : \(objects) to \(T.self) with error : \(error)")
    }
    return parsedResult
  }
  
  func parse<T: ImmutableMappable>(object: Any) throws -> Observable<T> {
    return Observable.create({ (observer: AnyObserver<T>) -> Disposable in
      do {
        let result: T = try self.parse(object: object)
        observer.on(.next(result))
        observer.on(.completed)
      } catch {
        observer.on(.error(error))
      }
      return Disposables.create()
    })
  }
  
  func parse<T: ImmutableMappable>(objects: Any) throws -> Observable<[T]> {
    return Observable.create({ (observer: AnyObserver<[T]>) -> Disposable in
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
}
