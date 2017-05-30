# Authentication
----
## OAuth2

### Token

Based on keychain service to store `accessTokenKey `, `refreshTokenKey ` and `expirationDateKey `

```swift
func clearToken()

func updateToken(token: String, refreshToken: String? = default, expiresIn: TimeInterval? = default)

func isTokenExpired() -> Bool

func currentAccessToken() -> String?

func currentRefreshToken() -> String?
```

## JWT

### Token
You can use the NetworkStack with JWT based authentication.
The difference with OAuth2 is the usage of ```func updateToken(token: String, refreshToken: String? = default, expiresIn: TimeInterval? = default)```
Just pass the `JWT` as `token` parameter.

Refer to [auto retry](AutoRetry.md) topic wether you want advanced authentication behaviour.