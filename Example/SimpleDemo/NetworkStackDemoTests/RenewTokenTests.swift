//
//  RenewTokenTests.swift
//  NetworkStackDemo
//
//  Created by Pierre DUCHENE on 31/05/2017.
//  Copyright © 2017 Niji. All rights reserved.
//

import XCTest
import NetworkStack
import Alamofire
import RxSwift
import OHHTTPStubs

class RenewTokenTests: NetworkStackTests {

  var networkStack: NetworkStack!
  let baseURL = "https://niji.fr"
  let initToken = "fakeInitialToken"
  var newToken: String { return "fakeRenewedToken" + "\(newTokenCount)" }
  var newTokenCount: Int = 0

  override func setUp() {
    super.setUp()

    let keychain = KeychainService(serviceType: "fr.niji.networkstack.test")
    networkStack = NetworkStack(baseURL: baseURL, keychainService: keychain)
    networkStack.updateToken(token: initToken)
    networkStack.renewTokenHandler = {
      self.newTokenCount += 1
      self.networkStack.updateToken(token: self.newToken)
      return Observable.just()
    }

    print("Current JWT : \(networkStack.currentAccessToken())")

  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testSimpleHTTP200() {
    let promise = expectation(description: "Get 200")

    let route: TestRoute = TestRoute("/test")
    let requestParameters = RequestParameters(method: .get,
                                              route: route,
                                              needsAuthorization: true)


    var counter: Int = 0
    stub(condition: pathEndsWith(route.path)) { _ in
      let stubPath = OHPathForFile("empty.json", type(of: self))
      counter += 1
      return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
    }

    _ = networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext : {_ in
        promise.fulfill()
      })

    waitForExpectations(timeout: kTimeout, handler: { _ in
      // Be sure, the request was send only once.
      XCTAssertEqual(counter, 1)
    })
  }

  func testSimpleHTTP401() {
    let promise = expectation(description: "testSimpleHTTP401")

    let route: TestRoute = TestRoute("/test")
    let requestParameters = RequestParameters(method: .get,
                                              route: route,
                                              needsAuthorization: true)


    var counter: Int = 0
    stub(condition: pathEndsWith(route.path)) { _ in
      let stubPath = OHPathForFile("empty.json", type(of: self))
      counter += 1
      return fixture(filePath: stubPath!, status: 401, headers: ["Content-Type":"application/json"])
    }

    _ = networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
    .subscribe(onError: { (error) in
      if let networkStackError = error as? NetworkStackError {
        switch networkStackError {
        case .http(let httpURLResponse, _):
          let code = httpURLResponse.statusCode
          XCTAssertEqual(code, 401, "Expected HTTP 401 error. Got \(code)")
          break
        default:
          XCTFail()
          break
        }
      } else {
        XCTFail()
      }

      promise.fulfill()
    })

    waitForExpectations(timeout: kTimeout, handler: { _ in
      // Be sure, the request was send twice.
      XCTAssertEqual(counter, 2)
    })
  }

  func testSimpleRenewToken() {
    let promise = expectation(description: "testSimpleRenewToken")

    let route: TestRoute = TestRoute("/test")
    let requestParameters = RequestParameters(method: .get,
                                              route: route,
                                              needsAuthorization: true)


    var counter: Int = 0
    stub(condition: pathEndsWith(route.path)) { _ in
      let stubPath = OHPathForFile("empty.json", type(of: self))
      counter += 1
      // First time return 401, second time return 200 OK
      if let token = self.networkStack.currentAccessToken(), token == self.newToken {
        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
      } else {
        return fixture(filePath: stubPath!, status: 401, headers: ["Content-Type":"application/json"])
      }
    }

    _ = networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext: { _ in
        promise.fulfill()
      },
                 onError: { (error) in
        XCTFail()
      })

    waitForExpectations(timeout: kTimeout, handler: { _ in
      // Check the token value
      let token = self.networkStack.currentAccessToken()
      XCTAssertNotNil(token)
      XCTAssertEqual(token, self.newToken)
    })
  }

  func testMultiRequestWithHTTP401() {
    let promise1 = expectation(description: "Request 1")
    let promise2 = expectation(description: "Request 2")

    let route: TestRoute = TestRoute("/test")
    let requestParameters = RequestParameters(method: .get,
                                              route: route,
                                              needsAuthorization: true)


    var counter: Int = 0
    stub(condition: pathEndsWith(route.path)) { _ in
      let stubPath = OHPathForFile("empty.json", type(of: self))
      counter += 1
      // First time return 401, second time return 200 OK
      if let token = self.networkStack.currentAccessToken(), token == self.newToken {
        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
      } else {
        return fixture(filePath: stubPath!, status: 401, headers: ["Content-Type":"application/json"])
      }
    }

    _ = networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext: { _ in
        promise1.fulfill()
      },
                 onError: { (error) in
                  XCTFail()
      })

    _ = networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext: { _ in
        promise2.fulfill()
      },
                 onError: { (error) in
                  XCTFail()
      })

    waitForExpectations(timeout: kTimeout, handler: { _ in
      let nbRequest = 1 + 2 // 1 first request with 401 error, and after the renwToken, the 2 request finally sent
      XCTAssertEqual(counter, nbRequest)

      // Check the token value
      let token = self.networkStack.currentAccessToken()
      XCTAssertNotNil(token)
      XCTAssertEqual(token, "fakeRenewedToken1")
    })
  }

}
