# Moya Comparison Example
 
### Serialization Services
With `NetworkStack` requests you can use two different return data : 

- `Data`
- `JSON`

In this example we have **four** different `JSON` serialization services : 

- [Decodable](MoyaComparison/Services/Serialization/Decodable/SerializationServiceDecodable.swift)
- [JSONCodable](MoyaComparison/Services/Serialization/JSONCodable/SerializationServiceJSONCodable.swift)
- [SwiftyJSON](MoyaComparison/Services/Serialization/SwiftyJSON/SerializationServiceSwiftyJSON.swift)
- [ObjectMapper](MoyaComparison/Services/Serialization/ObjectMapper/SerializationServiceObjectMapper.swift)

Right below we will see about implementation and difference between three of them.

## Serialization Comparison

|             |Decodable|JSONCodable|SwiftyJSON|ObjectMapper|
|:-----------:|:-------:|:---------:|:--------:|:----------:|
|Throwable    |   ✅    |    ✅    |          |      ✅    |
|Transformer  |         |    ✅    |          |      ✅    |
|Serializer   |         |    ✅    |    ✅    |      ✅    |
|Deserializer |   ✅    |    ✅    |    ✅    |      ✅    |
|Protocol conformance | **Decodable** | **JSONCodable** | | **Mappable** or **ImmutableMappable**|
|Mapper       |         |          |          |      ✅    |
|Parser       |   ✅    |    ✅   |    ✅    |      ✅    |

### Decodable

```swift
// decodable protocol conformance
decode(object: JSONObject) throws // deserialize
```
**Parser :** you can see here, [Decodable extension conformance](MoyaComparison/Models/Parser/Decodable/Video+Decodable.swift) for our `Realm` Video object.

**Documentation :**
[`Decodable`](https://github.com/Anviking/Decodable) 

### JSONCodable

```swift
// JSONCodable protocol conformance
decode(_ json: Any) throws -> T // deserialize
```

**Transformable :** `JSONTransformer` is a protocol to create transformers. Two default trnasformers is implement (`StringToURL` & `StringToDate`).

**Parser :** you can see here, [JSONCodable extension conformance](MoyaComparison/Models/Parser/JSONCodable/Video+JSONCodable.swift) for our Video `Realm` object.

**Documentation :**
[`JSONCodable`](https://github.com/matthewcheok/JSONCodable) 

### SwiftyJSON
This is a very flexible pod to **serialize and deserialize JSON**. There is no **protocol conformance**, but on this example we try to fix limits and usage. So we create `Swifty` protocol with conformance :

```swift
init(json: JSON) // deserialize
 
func toJSON() -> JSON // serialize
```
You can create your own protocol or not.

**Transformable :** map, flatmap to transform datas. Use everything you want to transform `JSON <-> Object`. You can create you own Tranformable protocol if needed. 

**Parser :** 
It's more flexible than `JSONCodable` and there are specific features like  `JSON` merging. you can se here, [SwiftyJSON extension conformance](MoyaComparison/Models/Parser/SwiftyJSON/Video+SwiftyJSON.swift) for our Video `Realm` object.

**Documentation :**
[`SwiftyJSON`](https://github.com/SwiftyJSON/SwiftyJSON) 

### ObjectMapper
It's a Mapper so it manages your object to map properties. Mapping means that you need to set all properties with `var` keyword. 

If you use Realm it would be guidelines to set all properties with `var` keyword. But as you know, a rule don't come without exceptions, and Realm has own properties like `RealmOptional<T>` & `List<T>` where the guideline is to set properties with `let` keyword. And use respectivily `realmOptional.value` and `realmlist.append()` to access and modifiy it correctly.  

**!! NOW !!** with `ImmutableMappable` protocol we can do something better. You can perform serialization and deserialization by yourself. With this protocol, `ObjectMapper` instroduce **immutable** principle. Right way to use it :

```swift
// ImmutableMappable protocol conformance
init(map: Map) throws // deserialize

func mapping(map: Map) // serialize
```
This protocol is under construction, so use it carefully. And to conclude, this protocol keep the legacy of `ObjectMapper` and it is difficult to understand why the mapper denomination exists inside this protocol cause it's now a parser.

**Transformable :** 
`TransformType` is a protocol to create transformers. You have multiple default transformers like :

- `DateFormatterTransform(dateFormatter: DateFormatter)`
- `EnumTransform<T: RawRepresentable>()`
- `NSDecimalNumberTransform()`
- `URLTransform(shouldEncodeURLString: Bool = true)`

**Parser :**
you can see here, [ObjectMapper extension conformance](MoyaComparison/Models/Parser/ObjectMapper/Video+ObjectMapper.swift) for our Video `Realm` object.

**Documentation :** 
[`ObjectMapper`](https://github.com/Hearst-DD/ObjectMapper) 

## Moya vs NetworkStack
You will see two network layers that have same possibilities.

### TargetType vs RequestParameters
`TargetType` is a centric object with required property that you need to create requests. `RequestParameters` is more flexible and you will be able to customize it what you want with few guidelines.

### RxSwift
`NetworkStack` is full `RxSwift` compare to `Moya` that you can choose between standard API, `RxSwift` and `ReactiveSwift`.

### table of comparison

|               Features            | NetworkStack  | Moya |
| --------------------------------- | :-----------: | :--: |
| Request with data response        |       ✅      | ✅  |
| Upload request with data response |       ✅      | ✅  |
| Request with JSON response        |       ✅      | ✅  |
| Upload request with JSON response |       ✅      | ✅  |
| JWT                               |               | ✅  |
| OAuth2                            |       ✅      | ✅  |
| auto retry auth                   |       ✅      |     |
| auto renew token                  |       ✅      |     |
| Plugins                           |               |  ✅ |
| Errors enum                       |       ✅      |     |

