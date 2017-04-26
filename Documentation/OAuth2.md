# OAuth2
----
## Authentication

### Token

Based on keychain service to store `accessTokenKey `, `refreshTokenKey ` and `expirationDateKey `

```swift
func clearToken()

func updateToken(token: String, refreshToken: String? = default, expiresIn: TimeInterval? = default)

func isTokenExpired() -> Bool

func currentAccessToken() -> String?

func currentRefreshToken() -> String?
```

Refer to [auto retry](AutoRetry.md) topic wether you want advanced authentication behaviour.