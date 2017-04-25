# Moya Comparison Example
 
### Serialization Services
With `NetworkStack` requests you can use two different objects : 

- `Data`
- `JSON`

In this example you have three differents `JSON` serialization services : 

- [JSONCodable](MoyaComparison/Services/Serialization/JSONCodable/SerializationServiceJSONCodable.swift)
- [SwiftyJSON](MoyaComparison/Services/Serialization/SwiftyJSON/SerializationServiceSwiftyJSON.swift)
- [ObjectMapper](MoyaComparison/Services/Serialization/ObjectMapper/SerializationServiceObjectMapper.swift)

You can see **Serialization Comparison** topic to know more about implementation and difference between three of them.

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
 