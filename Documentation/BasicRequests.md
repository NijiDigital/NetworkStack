# Basic requests

**Init NetworkStack :**

```swift

let baseStringURL = "http://networkstack.fr/api/v1"
let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.keychain")
let networkStack = NetworkStack(baseURL: baseStringURL, keychainService: keychainService)
```

**Request parameter to use to send request :**

```swift
let requestParameters = RequestParameters(method: .put,
                                          route: Route.video(identifier: 1),
                                          parameters: nil,
                                          parametersEncoding: URLEncoding.httpBody)
                                          
                                          networkStack.sendRequestWithDataResponse(requestParameters: requestParameters)
// OR
networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
```
