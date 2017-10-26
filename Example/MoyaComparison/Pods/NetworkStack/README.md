NetworkStack
===========
[![Language: Swift 4](https://img.shields.io/badge/Swift-4-orange.svg?style=flat-square)](https://swift.org)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/NetworkStack.svg?style=flat-square)](https://cocoapods.org/pods/NetworkStack)
[![CocoaPods](https://img.shields.io/cocoapods/p/NetworkStack.svg?style=flat-square)]()
[![Twitter](https://img.shields.io/badge/twitter-@Niji_Digital-blue.svg?style=flat-square)](http://twitter.com/Niji_Digital)
[![CocoaPods](https://img.shields.io/cocoapods/l/NetworkStack.svg?style=flat-square)](LICENSE)

<img src="cover.png">

`NetworkStack` is an networking library wrapping [Alamofire](https://github.com/Alamofire/Alamofire), [Rx](https://github.com/ReactiveX/RxSwift), `OAuth` and replay mechanism in a reactive abstract API.

# Features

This library features the following:

* Wraps your network calls into a RxSwift-compatible API, returning `Observable<T>` values rather than using completion blocks
* Handles the OAuth authentication workflow, allowing you to specify the credentials (which are stored in the Keychain) and let the library use them to enrich your authenticated requests for you
* Handles auto-retry in case of 401 authentication errors:
  * letting you execute the refreshToken request, then replay the request automatically
  * letting you present arbitrary login screen when credentials must be asked to the user in case the refreshToken isn't valid or available
* Simplifies the API so that your WebService client has a simple (and Alamofire-agnostic) API to call when it needs to send requests, without worrying about the internals.

# Installation

## CocoaPods

Using [CocoaPods](https://guides.cocoapods.org) is the recommended way :

- In your Podfile, add `use_frameworks!` and pod `NetworkStack` to your main and test targets.
- Run `pod repo update` to make CocoaPods aware of the latest available `NetworkStack` versions.
- Simply add `pod 'NetworkStack'` to your `Podfile`.

```ruby
pod 'NetworkStack'
```

From the command line, run `pod install`

# Documentation & Usage Examples
We have specific wiki. It will be helpful for you if you want to implement advanced or specific behaviour :

----------------

- [UploadRequests](Documentation/UploadRequests.md)
- [OAuth2](Documentation/OAuth2)
- [Auto retry](Documentation/AutoRetry.md)

----------------

## Simple Usage

### Setup

```swift
let baseStringURL = "http://networkstack.fr/api/v1"
let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.keychain")
let networkStack = NetworkStack(baseURL: baseStringURL, keychainService: keychainService)
```
You can customize your request in many way. Feel free to create your `SessionManager` to change behaviour of requesting inside `NetworkStack`. `NetworkStack` has two properties that you can set :

- **requestManager:** `Alamofire.SessionManager` is `Alamofire.SessionManager()` by default
- **uploadManager:**  `Alamofire.SessionManager` is `nil` by default

### Routes as Routable protocol

`NetworkStack` has **`Routable`** protocol to create path for endpoints of your requests.

```swift
public struct Route: Routable {
  public let path: String
  init(path: String) { self.path = path }
}

extension Route: CustomStringConvertible {
  public var description: String { return path }
}

extension Route {
  public static func authent() -> Route { return Route(path: "/authent") }
}
```

This is an implementation example but you are free to use it like you want.

### Request parameters

This is the core of requests creation. Request parameters can take :

**`RequestParameters`** :

- **method:** ` Alamofire.HTTPMethod`
- **route:** `Routable`
- **needsAuthorization:** `Bool = false`
- **parameters:** `Alamofire.Parameters? = nil`
- **parametersEncoding:** `Alamofire.ParameterEncoding = JSONEncoding.default`
- **headers:** `Alamofire.HTTPHeaders? = nil`

```swift
let requestParameters = RequestParameters(method: .get,
                                          route: Route.authent(),
                                          parameters: nil, // [String: Any] type
                                          needsAuthorization: false,
                                          parametersEncoding: URLEncoding.httpBody,
                                          headers: nil) // [String: String] type
```

***For Upload :** **`UploadRequestParameters`** :

- **method:** ` Alamofire.HTTPMethod = .post`
- **route:** `Routable`
- **needsAuthorization:** `Bool = true`
- **uploadFiles:** `[UploadRequestParametersFile]`
- **parameters:** `Alamofire.Parameters? = nil`
- **headers:** `Alamofire.HTTPHeaders? = nil`


### Requests

In public interface you can find this few methods that help you to send requests.

```swift
func sendRequestWithDataResponse(requestParameters: RequestParameters) -> Observable<(HTTPURLResponse, Data)>

func sendRequestWithJSONResponse(requestParameters: RequestParameters) -> Observable<(HTTPURLResponse, Any)>

// For Uploads
func sendUploadRequestWithDataResponse(uploadRequestParameters: UploadRequestParameters) -> Observable<(HTTPURLResponse, Data)>

func sendUploadRequestWithDataResponse(uploadRequestParameters: UploadRequestParameters) -> Observable<(HTTPURLResponse, Any)>

func sendBackgroundUploadRequest(uploadRequestParameters: UploadRequestParameters) -> Observable<URLSessionTask>
```

### Send request and response

```swift
networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
  .subscribe({ (event: Event<(HTTPURLResponse, Any)>) in
    switch event {
    case .next(let json):
      // do something with the json response or statusCode
      break
    case .error(let error):
      // do something with NetworkStackError
      break
    case .completed:
      // do something when observable completed
      break
    }
  }).addDisposableTo(self.disposeBag)
```

### Errors

Network stack provides several errors that you can handles in your app.

```swift
public enum NetworkStackError: Error {
  /// No internet, roaming off, data not allowed, call active, …
  case noInternet(error: Error)
  /// DNS Lookup failed, Host unreachable, …
  case serverUnreachable(error: Error)
  /// Invalid request, Fail to parse JSON, Unable to decode payload…
  case badServerResponse(error: Error)
  /// Response in 4xx-5xx range
  case http(httpURLResponse: HTTPURLResponse, data: Data?)
  /// Fail to parse response
  case parseError
  /// Other, unclassified error
  case otherError(error: Error)
  /// Request building has failed
  case requestBuildFail
  /// Upload manager has not been setup
  case uploadManagerIsNotSet
  /// Unknown
  case unknown
}
```

# More examples & Help Topics

We have some examples :

- [Simple demo](Example/SimpleDemo/README.md)
- [MoyaComparison](Example/MoyaComparison/README.md)

# Feedback

- If you found a **bug** , open an **issue**
- If you have a **feature request** , open an **issue**
- If you want to **contribute** , submit a **pull request**

# License

This code is distributed under [the Apache 2 License](LICENSE).
