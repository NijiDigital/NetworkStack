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
import RxSwift

class RenewTokenTests: NetworkStackTests {

  var networkStack: NetworkStack!
  let baseURL = "https://niji.fr"
  let initToken = "fakeInitialToken"
  var newToken: String { return "fakeRenewedToken" + "\(newTokenCount)" }
  var newTokenCount: Int = 0
  var disposeBag: DisposeBag = DisposeBag()

  override func setUp() {
    super.setUp()

    let keychain = KeychainService(serviceType: "fr.niji.networkstack.test")
    networkStack = NetworkStack(baseURL: baseURL, keychainService: keychain)
    networkStack.updateToken(token: initToken)
    networkStack.renewTokenHandler = {
      return Observable.create({ (observer) -> Disposable in
        self.newTokenCount += 1

        self.networkStack.updateToken(token: self.newToken)
        observer.onNext(())
        observer.onCompleted()

        return Disposables.create()
      })
    }
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()

    self.disposeBag = DisposeBag()
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

    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext : {_ in
        promise.fulfill()
      })
      .addDisposableTo(self.disposeBag)

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

    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
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
      .addDisposableTo(self.disposeBag)

    waitForExpectations(timeout: kTimeout, handler: { _ in
      // Be sure, the request was send twice.
      XCTAssertEqual(counter, 2)
      XCTAssertEqual(self.networkStack.currentAccessToken(), self.newToken)
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

    var nextCount: Int = 0
    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .do(onNext: { (_) in
        nextCount += 1
      },onError: { (error) in
        XCTFail()
      }, onCompleted: {
        promise.fulfill()
      })
      .subscribe()
      .addDisposableTo(self.disposeBag)


    waitForExpectations(timeout: kTimeout, handler: { _ in
      XCTAssertEqual(nextCount, 1)
      XCTAssertEqual(counter, 2)

      // Check the token value
      let token = self.networkStack.currentAccessToken()
      XCTAssertNotNil(token)
      XCTAssertEqual(token, self.newToken)
    })
  }

  func testMultiRequestWithHTTP401OnlyOneRenewSent() {
    if let token = self.networkStack.currentAccessToken() {
      XCTAssertEqual(token, initToken)
    }

    let promise1 = expectation(description: "Request 1")
    let promise2 = expectation(description: "Request 2")

    let route: TestRoute = TestRoute("/test")
    let requestParameters = RequestParameters(method: .get,
                                              route: route,
                                              needsAuthorization: true)


    var counter: Int = 0
    var counter200: Int = 0
    var counter401: Int = 0
    stub(condition: pathEndsWith(route.path)) { _ in
      let stubPath = OHPathForFile("empty.json", type(of: self))
      counter += 1
      // First time return 401, second time return 200 OK
      if counter > 1 {
        counter200 += 1
        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
      } else {
        counter401 += 1
        return fixture(filePath: stubPath!, status: 401, headers: ["Content-Type":"application/json"])
      }
    }

    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext: { _ in
        promise1.fulfill()
      }, onError: { (error) in
        XCTFail("Encounter error : \(error)")
      })
      .addDisposableTo(self.disposeBag)

    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext: { _ in
        promise2.fulfill()
      }, onError: { (error) in
        XCTFail("Encounter error : \(error)")
      })
      .addDisposableTo(self.disposeBag)

    waitForExpectations(timeout: kTimeout, handler: { _ in
      XCTAssertEqual(counter, 3)
      XCTAssertEqual(counter200, 2)
      XCTAssertEqual(counter401, 1)

      // Check the token value
      let token = self.networkStack.currentAccessToken()
      XCTAssertNotNil(token)
      XCTAssertEqual(token, "fakeRenewedToken1")
    })
  }

  func testMultiRequestWithHTTP401() {
    if let token = self.networkStack.currentAccessToken() {
      XCTAssertEqual(token, initToken)
    }

    let promise1 = expectation(description: "testMultiRequestWithHTTP401 Request 1")
    let promise2 = expectation(description: "testMultiRequestWithHTTP401 Request 2")
    let promise3 = expectation(description: "testMultiRequestWithHTTP401 Request 3")

    let route: TestRoute = TestRoute("/test")
    let requestParameters = RequestParameters(method: .get,
                                              route: route,
                                              needsAuthorization: true)


    var counter: Int = 0
    var counter200: Int = 0
    var counter401: Int = 0
    stub(condition: pathEndsWith(route.path)) { _ in
      let stubPath = OHPathForFile("empty.json", type(of: self))
      counter += 1
      // First time return 401, second time return 200 OK
      if counter > 1 {
        counter200 += 1
        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
      } else {
        counter401 += 1
        return fixture(filePath: stubPath!, status: 401, headers: ["Content-Type":"application/json"])
      }
    }

    var nextCount: Int = 0
    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .do(onNext: { (item: (response: HTTPURLResponse, data: Any)) in
        nextCount += 1
      })
      .subscribe(onNext: { _ in
      },
                 onError: { (error) in
                  XCTFail()
      }, onCompleted: {
        promise1.fulfill()
      })
      .addDisposableTo(self.disposeBag)

    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext: { _ in
        promise2.fulfill()
      },
                 onError: { (error) in
                  XCTFail()
      })
      .addDisposableTo(self.disposeBag)

    networkStack.sendRequestWithJSONResponse(requestParameters: requestParameters)
      .subscribe(onNext: { _ in
        promise3.fulfill()
      },
                 onError: { (error) in
                  XCTFail()
      })
      .addDisposableTo(self.disposeBag)

    waitForExpectations(timeout: kTimeout, handler: { _ in
      XCTAssertEqual(nextCount, 1)
      let nbRequest = 1 + 3 // 1 first request with 401 error, and after the renewToken, the 3 requests finally sent
      XCTAssertEqual(counter, nbRequest,"Expected 4 request, the first one with 401 error response. And then the 3 tests request. Here we have : \(counter)")

      XCTAssertEqual(counter401, 1)
      XCTAssertEqual(counter200, 3)
      
      // Check the token value
      let token = self.networkStack.currentAccessToken()
      XCTAssertNotNil(token)
      XCTAssertEqual(token, "fakeRenewedToken1")
    })
  }
  
}
