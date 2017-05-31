//
//  Tests+Utils.swift
//  NetworkStackDemo
//
//  Created by Pierre DUCHENE on 31/05/2017.
//  Copyright © 2017 Niji. All rights reserved.
//

import XCTest
import NetworkStack
import Alamofire
import OHHTTPStubs

struct TestRoute: Routable {
  public let path: String

  init(_ path: String) {
    self.path = path
  }


}

class NetworkStackTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func loadStubFile(_ name: String, status: Int32 = 200, forRoute route: TestRoute) {
    let path: String = route.path

    stub(condition: pathEndsWith(path)) { _ in
      let stubPath = OHPathForFile(name, type(of: self))
      return fixture(filePath: stubPath!, status: status, headers: ["Content-Type":"application/json"])
    }
  }
}
