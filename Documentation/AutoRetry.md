# Auto retry

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

If you set this property you can relaunch your authenticate workflow automaticly when required settings are satisfied :

- Are Authenticated
- Received a `401` or `403`
- Failed to renew token 
- `askCredentialHandler` is not `nil`

`askCredentials()`

## TODO

- [ ] Made conditions to **refresh token** public but with actual default behaviour.
- [ ] Made conditions to **renew authentication** public but with actual default behaviour.