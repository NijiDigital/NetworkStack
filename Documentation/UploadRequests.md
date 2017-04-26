# Upload Requests
----

### Init NetworkStack to use upload

```swift
let baseStringURL = "http://networkstack.fr/api/v1"
let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.keychain")
let uploadManager = SessionManagerFactory.backgroundUploadSessionManager("com.networkstack.uploadmanager")
    
let networkStack = NetworkStack(baseURL: baseStringURL,
                                keychainService: keychainService,
                                uploadManager: uploadManager)
```


### Upload request parameter to use to send upload request :

```swift
let fileURL = URL(string: "/var/mobile/Applications/Documents/my-id-card.pdf")!
let fileToUpload = UploadRequestParametersFile(fileURL: fileURL,
                                               parameterName: "idCard",
                                               fileName: "My ID card",
                                               mimeType: "application/pdf")
let uploadFiles = [fileToUpload]
    
let uploadRequestParameters = UploadRequestParameters(method: HTTPMethod.post,
                                                      route: Route.document(),
                                                      needsAuthorization: false,
                                                      uploadFiles: uploadFiles,
                                                      parameters: nil,
                                                      headers: nil)
networkStack.sendUploadRequestWithDataResponse(uploadRequestParameters: uploadRequestParameters)
// OR
networkStack.sendUploadRequestWithJSONResponse(uploadRequestParameters: uploadRequestParameters)
```
