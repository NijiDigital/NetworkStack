# Auto retry
----

## Auto refresh token

Compose with this property, you can inject it when you want :

```swift 
public var renewTokenHandler = () -> Observable<Void>
```

With previous property you can renew your token automaticly. Required settings are : 

- Are authenticiated 
- Received an error for a request with `401` or `404` server status code.
- `renewTokenHandler` is not nil

## Renew Authent if needeed

Compose with this optional property when you init NetworkStack :

```swift 
public var askCredentialHandler: () -> Observable<Void>
```

If you set this property you can relaunch your authenticate workflow automaticly when required settings are satisfied :

- Are Authenticated
- Received a `401` or `403`
- Failed to renew token 
- `askCredentialHandler` is not `nil`

### UPDATE :
`AskCredentials` is new struct to handle credentials. 

## TODO

- [ ] Make conditions to **refresh token** public but with actual default behaviour.
- [x] Make conditions to **renew authentication** public but with actual default behaviour.