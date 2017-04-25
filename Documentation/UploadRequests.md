# Upload Requests

**Init NetworkStack to use upload :**

```swift
let baseStringURL = "http://networkstack.fr/api/v1"
let keychainService: KeychainService = KeychainService(serviceType: "com.networkstack.keychain")
let uploadManager = SessionManager()
    
let networkStack = NetworkStack(baseURL: baseStringURL,
                                keychainService: keychainService,
                                uploadManager: uploadManager)
```


**Upload request parameter to use to send upload request :**

```swift
let fileURL = URL(string: "/var/mobile/Applications/Documents/myfile.pdf")!
let fileToUpload = UploadRequestParametersFile(fileURL: fileURL,
                                               parameterName: "??????????????????",
                                               fileName: "My File",
                                               mimeType: "application/pdf")
let uploadFiles = [fileToUpload]
    
let uploadRequestParameters = UploadRequestParameters(method: HTTPMethod.post,
                                                      route: Route.document(videoIdentifier: 1),
                                                      needsAuthorization: false,
                                                      uploadFiles: uploadFiles,
                                                      parameters: nil,
                                                      headers: nil)
networkStack.sendUploadRequestWithDataResponse(uploadRequestParameters: uploadRequestParameters)
// OR
networkStack.sendUploadRequestWithJSONResponse(uploadRequestParameters: uploadRequestParameters)
// OR 
networkStack.sendBackgroundUploadRequest(uploadRequestParameters: uploadRequestParameters)
```
