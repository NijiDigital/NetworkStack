//
//  NetworkStack.swift
//
//  Copyright © 2017 Niji. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import RxSwift
import Alamofire

class NetworkStack {
  
  // MARK: - Type aliases
  
  typealias AskCredentialHandler = (() -> Observable<Void>)
  typealias RenewTokenHandler = (() -> Observable<Void>)
  
  // MARK: - Properties
  
  fileprivate let disposeBag = DisposeBag()
  fileprivate let baseURL: String
  fileprivate let keychainService: KeychainService
  
  fileprivate(set) var uploadManager: Alamofire.SessionManager?
  fileprivate var requestManager: Alamofire.SessionManager
  
  fileprivate var askCredentialHandler: AskCredentialHandler?
  var renewTokenHandler: RenewTokenHandler?
  
  // MARK: - Setup
  
  init(baseURL: String,
       keychainService: KeychainService,
       requestManager: Alamofire.SessionManager = Alamofire.SessionManager(),
       uploadManager: SessionManager? = nil,
       askCredentialHandler: AskCredentialHandler? = nil) {
    
    self.baseURL = baseURL
    self.keychainService = keychainService
    self.uploadManager = uploadManager
    self.requestManager = requestManager
    self.askCredentialHandler = askCredentialHandler
  }
}

// MARK: - Cancellation
extension NetworkStack {
  
  func disconnect() -> Observable<Void> {
    return self.cancelAllRequest()
    .map({ [unowned self] () -> Void in
      return self.clearToken()
    })
  }
  
  fileprivate func cancelAllRequest() -> Observable<Void> {
    return Observable.just()
    .map { () -> Void in
      self.resetRequestManager()
    }
    .flatMap { () -> Observable<Void> in
      return self.resetUploadManager()
    }
  }
  
  fileprivate func resetRequestManager() {
    self.requestManager = self.recreateManager(manager: self.requestManager)
  }
  
  // TODO: Handle upload manager reset
  fileprivate func resetUploadManager() -> Observable<Void> {
    guard let uploadManager = self.uploadManager else {
      return Observable.just()
    }
    
    let configuration = uploadManager.session.configuration
    
    return Observable.create { observer -> Disposable in
      let sessionDelegate = uploadManager.delegate
      sessionDelegate.sessionDidBecomeInvalidWithError = { (session: URLSession, error: Error?) -> Void in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext()
        }
      }
      uploadManager.session.invalidateAndCancel()
      
      return Disposables.create()
    }
    .map { [weak self] () -> Void in
      self?.uploadManager = SessionManager(configuration: configuration)
    }
  }
  
  fileprivate func recreateManager(manager: SessionManager) -> SessionManager {
    let configuration = manager.session.configuration
    manager.session.invalidateAndCancel()
    return SessionManager(configuration: configuration)
  }
}

// MARK: - Request building
extension NetworkStack {
  
  func request(method: Alamofire.HTTPMethod,
               route: Routable,
               needsAuthorization: Bool = false,
               parameters: Alamofire.Parameters? = nil,
               headers: Alamofire.HTTPHeaders? = nil,
               encoding: Alamofire.ParameterEncoding = JSONEncoding.default) -> DataRequest? {
    guard let requestUrl = self.requestURL(route) else {
      return nil
    }
    
    let requestHeaders = self.requestHeaders(needsAuthorization: needsAuthorization, headers: headers)
    
    return self.requestManager.request(requestUrl,
                                       method: method,
                                       parameters: parameters,
                                       encoding: encoding,
                                       headers: requestHeaders)
  }
  
  fileprivate func buildRequest(requestParameters: RequestParameters) -> DataRequest? {
    return self.request(method: requestParameters.method,
                        route: requestParameters.route,
                        needsAuthorization: requestParameters.needsAuthorization,
                        parameters: requestParameters.parameters,
                        headers: requestParameters.headers,
                        encoding: requestParameters.parametersEncoding)
  }
  
  fileprivate func requestURL(_ route: Routable) -> URL? {
    guard let requestUrl = URL(string: self.baseURL + route.path) else {
      return nil
    }
    return requestUrl
  }
  
  fileprivate func requestHeaders(needsAuthorization: Bool = false, headers: Alamofire.HTTPHeaders?) -> Alamofire.HTTPHeaders {
    var requestHeaders: Alamofire.HTTPHeaders
    if let headers = headers {
      requestHeaders = headers
    } else {
      requestHeaders = [:]
    }
    
    if needsAuthorization {
      let tokenValue = self.auhtorizationHeaderValue()
      if let tokenAutValue = tokenValue {
        requestHeaders["Authorization"] = tokenAutValue
      }
    }
    if let headers = headers {
      for (key, value) in headers {
        requestHeaders[key] = value
      }
    }
    return requestHeaders
  }
}

// MARK: - Request validation
extension NetworkStack {
  fileprivate func validateRequest(request: Alamofire.DataRequest) -> Alamofire.DataRequest {
    return request.validate(statusCode: 200 ..< 300)
  }
}

// MARK: - Retry management

extension NetworkStack {
  fileprivate func askCredentialsIfNeeded(forError error: Error) -> Observable<Void> {
    if self.shouldAskCredentials(forError: error) == true {
      return self.askCredentials()
    } else {
      return Observable.just()
    }
  }
  
  fileprivate func askCredentials() -> Observable<Void> {
    guard let askCredentialHandler = self.askCredentialHandler else {
      return Observable.just()
    }
    
    return Observable.just()
    .map({ [unowned self] () -> Void in
      self.clearToken()
    })
    .flatMap({ () -> Observable<Void> in
      return askCredentialHandler()
    })
  }
  
  fileprivate func shouldRenewToken(forError error: Error) -> Bool {
    var shouldRenewToken = false
    if case NetworkStackError.http(httpURLResponse: let httpURLResponse, data: _) = error, httpURLResponse.statusCode == 401 {
      shouldRenewToken = true
    }
    return shouldRenewToken
  }
  
  fileprivate func shouldAskCredentials(forError error: Error) -> Bool {
    var shouldAskCredentials = false
    if case NetworkStackError.http(httpURLResponse: let httpURLResponse, data: _) = error, httpURLResponse.statusCode == 401 || httpURLResponse.statusCode == 403 {
      shouldAskCredentials = true
    }
    return shouldAskCredentials
  }
  
  fileprivate func sendAutoRetryRequest<T>(_ sendRequestBlock: @escaping () -> Observable<T>, renewTokenFunction: @escaping () -> Observable<Void>) -> Observable<T> {
    return sendRequestBlock()
    .catchError { [unowned self] (error: Error) -> Observable<T> in
      if self.shouldRenewToken(forError: error) {
        return renewTokenFunction()
        .do(onError: { [unowned self] error in
          // Ask for credentials if renew token fail for any reason
          self.askCredentials()
            .subscribe()
            .addDisposableTo(self.disposeBag)
        })
        .flatMap(sendRequestBlock)
      } else {
        throw error
      }
    }
  }
}

// MARK: - Error management

extension NetworkStack {
  
  fileprivate func webserviceStackError(error: Error, httpURLResponse: HTTPURLResponse?, responseData: Data?) -> NetworkStackError {
    let finalError: NetworkStackError
    
    switch error {
    case URLError.notConnectedToInternet, URLError.cannotLoadFromNetwork, URLError.networkConnectionLost,
         URLError.callIsActive, URLError.internationalRoamingOff, URLError.dataNotAllowed:
      finalError = NetworkStackError.noInternet(error: error)
    case URLError.cannotConnectToHost, URLError.cannotFindHost, URLError.dnsLookupFailed, URLError.redirectToNonExistentLocation:
      finalError = NetworkStackError.serverUnreachable(error: error)
    case URLError.badServerResponse, URLError.cannotParseResponse, URLError.cannotDecodeContentData, URLError.cannotDecodeRawData:
      finalError = NetworkStackError.badServerResponse(error: error)
    default:
      if let httpURLResponse = httpURLResponse, 400..<600 ~= httpURLResponse.statusCode {
        finalError = NetworkStackError.http(httpURLResponse: httpURLResponse, data: responseData)
      } else {
        finalError = NetworkStackError.otherError(error: error)
      }
    }
    
    return finalError
  }
}

// MARK: - Request
extension NetworkStack {
  
  fileprivate func sendRequest<T: DataResponseSerializerProtocol>(
    alamofireRequest: Alamofire.DataRequest,
    queue: DispatchQueue = DispatchQueue.global(qos: .default),
    responseSerializer: T)
    -> Observable<(HTTPURLResponse, T.SerializedObject)> {
      return Observable.create { [unowned self] observer in
        self.validateRequest(request: alamofireRequest)
          .response(queue: queue, responseSerializer: responseSerializer) { [unowned self] (packedResponse: DataResponse<T.SerializedObject>) -> Void in
            
            switch packedResponse.result {
            case .success(let result):
              if let httpResponse = packedResponse.response {
                observer.onNext(httpResponse, result)
              } else {
                observer.onError(NetworkStackError.unknown)
              }
              observer.onCompleted()
            case .failure(let error):
              let networkStackError = self.webserviceStackError(error: error, httpURLResponse: packedResponse.response, responseData: packedResponse.data)
              observer.onError(networkStackError)
            }
        }
        return Disposables.create {
          alamofireRequest.cancel()
        }
      }
      .subscribeOn(ConcurrentDispatchQueueScheduler(queue: queue))
  }
  
  fileprivate func sendRequest<T: DataResponseSerializerProtocol>(requestParameters: RequestParameters,
                               queue: DispatchQueue = DispatchQueue.global(qos: .default),
                               responseSerializer: T) -> Observable<(HTTPURLResponse, T.SerializedObject)> {
    guard let request = self.buildRequest(requestParameters: requestParameters) else {
      return Observable.error(NetworkStackError.requestBuildFail)
    }
    
    if requestParameters.needsAuthorization {
      return self.sendAuthenticatedRequest(request: request, queue: queue, responseSerializer: responseSerializer)
    } else {
      return self.sendRequest(alamofireRequest: request, queue: queue, responseSerializer: responseSerializer)
    }
  }
  
  fileprivate func sendAuthenticatedRequest<T: DataResponseSerializerProtocol>(
    request: Alamofire.DataRequest,
    queue: DispatchQueue = DispatchQueue.global(qos: .default),
    responseSerializer: T) -> Observable<(HTTPURLResponse, T.SerializedObject)> {
    
    let requestObservable: Observable<(HTTPURLResponse, T.SerializedObject)>
    
    if let renewTokenHandler = self.renewTokenHandler {
      requestObservable = self.sendAutoRetryRequest({ [unowned self] () -> Observable<(HTTPURLResponse, T.SerializedObject)> in
        return self.sendRequest(alamofireRequest: request, queue: queue, responseSerializer: responseSerializer)
        }, renewTokenFunction: { () -> Observable<Void> in
          return renewTokenHandler()
      })
    } else {
      requestObservable = self.sendRequest(alamofireRequest: request, queue: queue, responseSerializer: responseSerializer)
    }
    
    return requestObservable
    .do(onError: { [unowned self] error in
      self.askCredentialsIfNeeded(forError: error)
      .subscribe()
      .addDisposableTo(self.disposeBag)
    })
  }
}

// MARK: - Upload request
extension NetworkStack {
  
  fileprivate func sendUploadRequest<T: DataResponseSerializerProtocol>(uploadRequestParameters: UploadRequestParameters,
                                     queue: DispatchQueue = DispatchQueue.global(qos: .default),
                                     responseSerializer: T) -> Observable<(HTTPURLResponse, T.SerializedObject)> {
    
    let requestHeaders = self.requestHeaders(needsAuthorization: uploadRequestParameters.needsAuthorization,
                                             headers: uploadRequestParameters.headers)
    
    return Observable.create({ (observer) -> Disposable in
      guard let requestURL = self.requestURL(uploadRequestParameters.route) else {
        observer.onError(NetworkStackError.requestBuildFail)
        return Disposables.create()
      }
      
      guard let uploadManager = self.uploadManager else {
        observer.onError(NetworkStackError.uploadManagerIsNotSet)
        return Disposables.create()
      }
      
      uploadManager.upload(multipartFormData: { [weak self] (multipartFormData) in
        self?.enrichMultipartFormData(multipartFormData: multipartFormData,
                                      from: uploadRequestParameters)
        }, to: requestURL.absoluteString,
           headers: requestHeaders,
           encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let uploadRequest, _, _):
              observer.onNext(uploadRequest)
              observer.onCompleted()
            case .failure(let encodingError):
              observer.onError(encodingError)
            }
      })
      
      return Disposables.create()
    })
    .flatMap { [unowned self] uploadRequest -> Observable<(HTTPURLResponse, T.SerializedObject)> in
      return self.sendRequest(alamofireRequest: uploadRequest, queue: queue, responseSerializer: responseSerializer)
    }
  }
  
  func sendBackgroundUploadRequest(uploadRequestParameters: UploadRequestParameters) -> Observable<URLSessionTask> {
    return Observable.create({ [unowned self] (observer) -> Disposable in
      
      guard let requestURL = self.requestURL(uploadRequestParameters.route) else {
        observer.onError(NetworkStackError.requestBuildFail)
        return Disposables.create()
      }
      
      guard let uploadManager = self.uploadManager else {
        observer.onError(NetworkStackError.uploadManagerIsNotSet)
        return Disposables.create()
      }
      
      let requestHeaders = self.requestHeaders(needsAuthorization: uploadRequestParameters.needsAuthorization,
                                               headers: uploadRequestParameters.headers)
      
      uploadManager.upload(multipartFormData: { [weak self] (multipartFormData) in
        self?.enrichMultipartFormData(multipartFormData: multipartFormData, from: uploadRequestParameters)
      }, to: requestURL.absoluteString,
         headers: requestHeaders,
         encodingCompletion: {  (encodingResult) in
          switch encodingResult {
          case .success(let uploadRequest, _, _):
            if let urlSessionTask = uploadRequest.task {
              observer.onNext(urlSessionTask)
              observer.onCompleted()
            }
          case .failure(let error):
            observer.onError(error)
          }
      })
      
      return Disposables.create()
    })
  }
  
  fileprivate func enrichMultipartFormData(multipartFormData: MultipartFormData,
                                           from uploadRequestParameters: UploadRequestParameters) {
    
    for fileToUpload in uploadRequestParameters.uploadFiles {
      multipartFormData.append(fileToUpload.fileURL,
                               withName: fileToUpload.parameterName,
                               fileName: fileToUpload.fileName,
                               mimeType: fileToUpload.mimeType)
    }
    guard let params = uploadRequestParameters.parameters else {
      return
    }
    
    for (key, value) in params {
      let data: Data?
      
      switch value {
      case let valueData as Data:
        data = valueData
      case let valueString as String:
        data = valueString.data(using: String.Encoding.utf8)
      default:
        let strValue = String(describing: value)
        data = strValue.data(using: String.Encoding.utf8)
      }
      
      if let data = data {
        multipartFormData.append(data, withName: key)
      }
    }
  }
}

// MARK: - Data request
extension NetworkStack {
  
  func sendRequestWithDataResponse(requestParameters: RequestParameters,
                                   queue: DispatchQueue = DispatchQueue.global(qos: .default)) -> Observable<(HTTPURLResponse, Data)> {
    let responseSerializer = DataRequest.dataResponseSerializer()
    return self.sendRequest(requestParameters: requestParameters,
                            queue: queue,
                            responseSerializer: responseSerializer)
  }
  
  func sendUploadRequestWithDataResponse(uploadRequestParameters: UploadRequestParameters,
                                         queue: DispatchQueue = DispatchQueue.global(qos: .default)) -> Observable<(HTTPURLResponse, Data)> {
    let responseSerializer = DataRequest.dataResponseSerializer()
    return self.sendUploadRequest(uploadRequestParameters: uploadRequestParameters,
                                  queue: queue,
                                  responseSerializer: responseSerializer)
  }
}

// MARK: - JSON request
extension NetworkStack {
  
  fileprivate func defaultJSONResponseSerializer() -> DataResponseSerializer<Any> {
    let jsonOption = JSONSerialization.ReadingOptions.allowFragments
    return DataRequest.jsonResponseSerializer(options: jsonOption)
  }
  
  func sendRequestWithJSONResponse(requestParameters: RequestParameters,
                                   queue: DispatchQueue = DispatchQueue.global(qos: .default)) -> Observable<(HTTPURLResponse, Any)> {
    let responseSerializer = self.defaultJSONResponseSerializer()
    return self.sendRequest(requestParameters: requestParameters,
                            queue: queue,
                            responseSerializer: responseSerializer)
  }
  
  func sendUploadRequestWithJSONResponse(uploadRequestParameters: UploadRequestParameters,
                                         queue: DispatchQueue = DispatchQueue.global(qos: .default)) -> Observable<(HTTPURLResponse, Any)> {
    let responseSerializer = self.defaultJSONResponseSerializer()
    return self.sendUploadRequest(uploadRequestParameters: uploadRequestParameters,
                                  queue: queue,
                                  responseSerializer: responseSerializer)
  }
}



// MARK: - OAuth
extension NetworkStack {
  fileprivate func auhtorizationHeaderValue() -> String? {
    guard let accessToken = self.keychainService.accessToken, self.keychainService.isAccessTokenValid else {
      return nil
    }
    return "bearer \(accessToken)"
  }
  
  func clearToken() {
    self.keychainService.accessToken = nil
    self.keychainService.refreshToken = nil
    self.keychainService.expirationInterval = nil
  }
  
  func updateToken(token: String, refreshToken: String? = nil, expiresIn: TimeInterval? = nil) {
    self.keychainService.accessToken = token
    self.keychainService.refreshToken = refreshToken
    self.keychainService.expirationInterval = expiresIn
  }
  
  // Returns true if token is expired, and the app should show the authentication view
  func isTokenExpired() -> Bool {
    return self.keychainService.isAccessTokenValid == false
  }
  
  func currentAccessToken() -> String? {
    return self.keychainService.accessToken
  }
  
  func currentRefreshToken() -> String? {
    return self.keychainService.refreshToken
  }
}
