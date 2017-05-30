# Auto retry
----

## Auto refresh token

Using this property, you can tell your code how to renew the token. Typically, this closure will contain code to perform the "RefreshToken" request, parse the response, update the token stored in your NetworkStack, and emit a Observable.just() to tell when it's done.

```swift 
public var renewTokenHandler = () -> Observable<Void>
```

With this property you can renew your token automatically. This closure will be called when: 

- You're authenticated
- But you received an 401 error for a request
- That renewTokenHandler closure is not nil

## Renew Authent if needeed

Compose with this optional property when you init NetworkStack:

```swift 
public var askCredential: AskCredential?
```

If you set this property you can relaunch your authenticate workflow automatically. This property is a struct that encapsulate a closure to handle re-authentication process and a condition to know when trigger the closure.
This closure will be called when:

- You're Authenticated
- But you received an 401 error for a request
- The renew token fail
- That `askCredential` property is not `nil`

Unlike renew token process, askCredential doesn't replay the initial request.

## TODO

- [ ] Make renewTokenHandler same as askCredential property for consistency. [Issue #22](https://github.com/NijiDigital/NetworkStack/issues/22)
- [ ] Make conditions to **refresh token** public but with actual default behaviour. Will be done with [Issue #22](https://github.com/NijiDigital/NetworkStack/issues/22)
- [x] Make conditions to **renew authentication** public but with actual default behaviour.