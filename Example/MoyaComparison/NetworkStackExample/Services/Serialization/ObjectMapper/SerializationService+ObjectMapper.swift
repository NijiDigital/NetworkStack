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
  func toJSON<T: Mappable>(object: T) -> JSONObject {
    let mapper = Mapper<T>()
    return mapper.toJSON(object) as JSONObject
  }
  
  func toJSON<T: Mappable>(objects: [T]) -> JSONArray {
    let mapper = Mapper<T>()
    return mapper.toJSONArray(objects) as JSONArray
  }
  
  func toJSON<T: Mappable>(object: T) -> Observable<JSONObject> {
    return Observable.create({ (observer: AnyObserver<JSONObject>) -> Disposable in
      let mapper = Mapper<T>()
      let result = mapper.toJSON(object) as JSONObject
      observer.on(.next(result))
      observer.on(.completed)
      return Disposables.create()
    })
  }
  
  func toJSON<T: Mappable>(objects: [T]) -> Observable<JSONArray> {
    return Observable.create({ (observer: AnyObserver<JSONArray>) -> Disposable in
      let mapper = Mapper<T>()
      let result =  mapper.toJSONArray(objects) as JSONArray
      observer.on(.next(result))
      observer.on(.completed)
      return Disposables.create()
    })
  }
  
  // MARK: Parse funcs
  func parse<T: Mappable>(object: Any) throws -> T {
    guard let parsedResult = Mapper<T>().map(JSONObject: object) else {
      throw SerializationServiceError.unexpectedFormat(json: "Failed to parse json : \(object) to \(T.self)")
    }
    return parsedResult
  }
  
  func parse<T: Mappable>(objects: Any) throws -> [T] {
    guard let parsedResult = Mapper<T>().mapArray(JSONObject: objects) else {
      throw SerializationServiceError.unexpectedFormat(json: "Failed to parse json : \(objects) to \(T.self)")
    }
    return parsedResult
  }
  
  func parse<T: Mappable>(object: Any) throws -> Observable<T> {
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
  
  func parse<T: Mappable>(objects: Any) throws -> Observable<[T]> {
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
