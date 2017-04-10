NetworkStack
===========
[![Language: Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg?style=flat-square)](https://swift.org)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/NetworkStack.svg?style=flat-square)](https://cocoapods.org/pods/NetworkStack)
![Platform](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-333333.svg?style=flat-square)
[![Twitter](https://img.shields.io/badge/twitter-@Niji_Digital-blue.svg?style=flat-square)](http://twitter.com/Niji_Digital)
[![CocoaPods](https://img.shields.io/cocoapods/l/NetworkStack.svg?style=flat-square)](LICENSE)
 

`NetworkStack` is a network library to send requests easily. Based on [Alamofire](https://github.com/Alamofire/Alamofire), you will find all your habits. This is the best way to work with [RxSwift](https://github.com/ReactiveX/RxSwift) and [Alamofire](https://github.com/Alamofire/Alamofire) to add some functionnalities like automatic renewing token or upload files.
 

# Installing in your projects
 
## CocoaPods

Using [CocoaPods](https://guides.cocoapods.org) is the recommended way :

- In your Podfile, add `use_frameworks!` and pod `RealmSwift` to your main and test targets.
- Run pod repo update to make CocoaPods aware of the latest available Realm versions.
- Simply add `pod 'NetworkStack'` to your `Podfile`.

```ruby
pod 'NetworkStack'
```

From the command line, run `pod install`

# Documentation & Usage Examples

We have specific wiki with [full documentation](Documentation/README.md). It will be helpful for you if you want to implement specific behaviour. We support : 

- Basic Requests
- Upload Requests
- OAuth2
- Custom Request from Alamofire
- Custom SessionManager


##Simple Usage

### Init
```swift
let baseStringURL = "http://networkstack.fr/api/v1"
let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.keychain")
let networkStack = NetworkStack(baseURL: baseStringURL, keychainService: keychainService)
```

### RequestParameters
```swift
let requestParameters = RequestParameters(method: .get,
                                          route: Route.videos(),
                                          parameters: nil, // [String: Any] type
                                          needsAuthorization: false,
                                          parametersEncoding: URLEncoding.httpBody,
                                          headers: nil) // [String: String] type
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

## More examples & Help Topics
    
* For a lot more examples, see the dedicated "[Usage Examples](Example/README.md)" wiki page.

# License

This code is distributed under [the Apache 2 License](LICENSE).