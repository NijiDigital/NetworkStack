# Moya Comparison Example
 
## NetworkStack

### Setup 
```swift
let baseStringURL = "http://networkstack.fr/api/v1"
let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.keychain")
let networkStack = NetworkStack(baseURL: baseStringURL, keychainService: keychainService)
```
To customize your request you have flexibility. Free for you to create your `SessionManager` to change behaviour of requesting inside `NetworkStack`. `NetworkStack` has two properties that you can set :

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

### RequestParameters
This is the core of requests creation. Request parameters can take : 

**`RequestParameters`** :

- **method:** ` Alamofire.HTTPMethod`
- **route:** `Routable`
- **needsAuthorization:** `Bool = false`
- **parameters:** `Alamofire.Parameters? = nil`
- **parametersEncoding:** `Alamofire.ParameterEncoding = JSONEncoding.default`
- **headers:** `Alamofire.HTTPHeaders? = nil`


***For Upload :** **`UploadRequestParameters`** :

- **method:** ` Alamofire.HTTPMethod = .post`
- **route:** `Routable`
- **needsAuthorization:** `Bool = true`
- **uploadFiles:** `[UploadRequestParametersFile]`
- **parameters:** `Alamofire.Parameters? = nil`
- **headers:** `Alamofire.HTTPHeaders? = nil`

### Requests

```swift
func sendRequestWithDataResponse(requestParameters: RequestParameters) -> Observable<(HTTPURLResponse, Data)>

func sendRequestWithJSONResponse(requestParameters: RequestParameters) -> Observable<(HTTPURLResponse, Any)>

// For Uploads
func sendUploadRequestWithDataResponse(uploadRequestParameters: UploadRequestParameters) -> Observable<(HTTPURLResponse, Data)>

func sendUploadRequestWithDataResponse(uploadRequestParameters: UploadRequestParameters) -> Observable<(HTTPURLResponse, Any)>

func sendBackgroundUploadRequest(uploadRequestParameters: UploadRequestParameters) -> Observable<URLSessionTask>
```

### Serialization Services
With previous requests you can use two different objects : 

- `Data`
- `JSON`

In this example you have three differents `JSON` serialization services : 

- [JSONCodable](MoyaComparison/Services/Serialization/JSONCodable/SerializationServiceJSONCodable.swift)
- [SwiftyJSON](MoyaComparison/Services/Serialization/SwiftyJSON/SerializationServiceSwiftyJSON.swift)
- [ObjectMapper](MoyaComparison/Services/Serialization/ObjectMapper/SerializationServiceObjectMapper.swift)

You can see **Serialization Comparison** topic to know more about implementation and difference between three of them.

### Authentication

**Token**

Based on keychain service to store `accessTokenKey `, `refreshTokenKey ` and `expirationDateKey `

```swift
func clearToken()

func updateToken(token: String, refreshToken: String? = default, expiresIn: TimeInterval? = default)

func isTokenExpired() -> Bool

func currentAccessToken() -> String?

func currentRefreshToken() -> String?
```

**Auto refresh token**

Compose with this property, tyou can inject this property when you want :

```swift 
var renewTokenHandler = () -> Observable<Void>
```

If you set this property you can renew you token automaticly. Required settings are : 

- Are authenticiated 
- Received an error for a request with `401` or `404` server status code.
- `renewTokenHandler` is not nil

**Renew Authent if needeed**

Compose with this property optional when you init NetworkStack :

```swift 
var askCredentialHandler: () -> Observable<Void>
```

If you set this property you can authenticate automaticly. Required settings are :

- Are Authenticated
- Received a `401` or `403`
- Failed to renew token 
- `askCredentialHandler` is not `nil`

`askCredentials()`

### Errors 
Network stack use several error that you can use to manage your app errors. 

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

## Serialization Comparison

### Decodable
**Works :** focus on deserialization. Your object needs to conform `Decodable` protocol. 

```swift
decode(object: JSONObject) throws // deserialize
```

`JSONCodable` works with `coder` and `decoder` to serialize and deserialize Objects.

**Error handling :** `JSONCodable` is based on throwable to catch error. That you have easy to understand error.

**Transformable :** Don't need tranformer because is flexibility.

**Serialization Service :** you can se here, [JSONCodable file conformance](MoyaComparison/Models/Mapper/JSONCodable/Video+JSONCodable.swift) for our Realm Video object.

`JSONCodable` [documentation](https://github.com/matthewcheok/JSONCodable) 

### JSONCodable
**Works :** focus on serialization. Your object needs to conform `JSONCodable` protocol. 

```swift
decode(_ json: Any) throws -> T // deserialize
```

[JSONCodable file](MoyaComparison/Models/Parser/JSONCodable/Video+JSONCodable.swift) conformance example.

`Decoable` just deserialize your `JSON`. 

**Error handling :** `Decodable` throw.

**Transformable :** `JSONTransformer` is a protocol to create transformers. Two default trnasformers is implement (`StringToURL` & `StringToDate`) for me it is enough for all principle usages.

**Serialization Service :** you can se here, [Decodable file conformance](MoyaComparison/Models/Parser/JSONCodable/Video+JSONCodable.swift) for our Realm Video object.

`JSONCodable` [documentation](https://github.com/matthewcheok/JSONCodable) 

### SwiftyJSON
**Works :** No conformance protocol, but on this example we try to fix limits and usage. This is a very flexible pod to serialize and deserialize JSON. We create in this example `Swifty` protocol with conformance :

```swift
init(json: JSON) // deserialize
 
func toJSON() -> JSON // serialize
```

You can create your own protocol. That is flexibility.

**Error handling :** easy to use error, but not very easy to understand. 

**Transformable :** map, flatmap use everything you want to transform JSON <-> Object. You can create you own Tranformable protocol if needed. 

**Serialization Service :** 

It's a more flexible than `JSONCodable`.
And have a specific feature : `JSON` merging. Refer to **Parsing** section to know about files that you want to see.

`SwiftyJSON` [documentation](https://github.com/SwiftyJSON/SwiftyJSON) 

### ObjectMapper
**Works :** it's a Mapper so it manages your object to map properties. Mapping means that you need to set all properties with `var` keyword. 

If you use Realm it would be guidelines to set all properties with `var` keyword, but as you know, a rule don't come without exceptions, and Realm has own properties like `RealmOptional<T>` & `List<T>` where the guideline is to set properties with `let` keyword and use respectivily `realmOptional.value` and `realmlist.append()` to access and modifiy it correctly. 

It works fine with `ObjectMapper` if you use a value like `RealmOptional<T>()` & `List<T>()` that is define realm properties by default. With `Mappable` protocol, `ObjectMapper` is not really intersting because you loose immutable principle. 

**!! NOW !!** with `ImmutableMappable` protocol we can do something better. You can perform serialization and deserialization by yourself. With this protocol, ObjectMapper instroduce `Immutable` principle into it. Right way to use it :

```swift
init(map: Map) throws // deserialize

func mapping(map: Map) // serialize
```
This protocol is under construction, so use it carefully.

**Error handling :** `ObjectMapper` can throw error.

**Transformable :** `TransformType` is a protocol to create transformers. You have multiple default transformers like :

- `DateFormatterTransform(dateFormatter: DateFormatter)`
- `EnumTransform<T: RawRepresentable>()`
- `NSDecimalNumberTransform()`
- `URLTransform(shouldEncodeURLString: Bool = true)`

**Parsing :** 


`ObjectMapper` [documentation](https://github.com/Hearst-DD/ObjectMapper) 

## Moya vs NetworkStack
You see two network layers that have same possibility.

### TargetType vs RequestParameters


### RxSwift


### table of comparison

|               Features            | NetworkStack  | Moya | 
| --------------------------------- | :-----------: | :--: |
| Request with data response        |       ✅      | ✅  |
| Upload request with data response |       ✅      | ✅  |
| Request with JSON response        |       ✅      | ✅  |
| Upload request with JSON response |       ✅      | ✅  |
| Authentication OAuth/JWT          |       ✅      | ✅  |
| auto retry auth                   |       ✅      |     |
| auto renew token                  |       ✅      |     |
| Plugins                           |               |  ✅ |
| Errors enum                       |       ✅      |     |
 