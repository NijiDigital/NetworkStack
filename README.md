# NetworkStack

NetworkStack is an networking library wrapping Alamofire, Rx, OAuth and replay mechanism in a reactive abstract API

## Features

This library features the following:

* Wraps your network calls into a RxSwift-compatible API, returning `Observable<T>` values rather than using completion blocks
* Handles the OAuth authentication workflow, allowing you to specify the credentials (which are stored in the Keychain) and let the library use them to enrich your authenticated requests for you
* Handles auto-retry in case of 401 authentication errors:
  * letting you execute the refreshToken request, then replay the request automatically
  * letting you present arbitrary login screen when credentials must be asked to the user in case the refreshToken isn't valid or available
* Simplifies the API so that your WebService client has a simple (and Alamofire-agnostic) API to call when it needs to send requests, without worrying about the internals.

## Documentation

The full documentation is still being written and pending validation.
[A `NetworkStack-documentation` Git branch is available to see the work in progress on this documentation](https://github.com/NijiDigital/NetworkStack/tree/NetworkStack-documentation), but still hasn't been merged yet because it still needs some more work.

This paragraph will be updated once the branch is merged. In the meantime you can [take a look at the branch if you want to read the in-progress documentation](https://github.com/NijiDigital/NetworkStack/blob/NetworkStack-documentation/README.md).

## Example code

You can find some sample projects to demonstrate its usage in the `Example/` folder.

Especially one of the example compares `NetworkStack` with other similar libraries like `Moya` and shows how they differ.

## License

This code is distributed under [the Apache 2 License](LICENSE).
