//
//  TokenManager.swift
//  Pods
//
//  Created by Pierre DUCHENE on 31/05/2017.
//
//

import Foundation
import RxSwift

/**
 TokenManager is responsible of token management for the NetworkStack
 It manage the request flow, tu ensure that only one refresh token request was send,
 and to prevent all observer when new token will arrive
 */
class TokenManager {

  // MARK: - Properties

  /// This observable is used to get a new token if needed
  private let tokenFetcher: Observable<String>

  /// using Rx Variable instead of direct String, 
  /// this way, when you call fetchToken(), access to value is only done at subscribe time
  private let currentToken: Variable<String?> = Variable<String?>(nil)

  /// Using weak var for this property.
  /// The goal is to automatiquely set back to nil when no more observer subscribe
  private weak var currentFetcher: Observable<String>?

  // MARK: - Init

  init(tokenFetcher: Observable<String>) {
    self.tokenFetcher = tokenFetcher
  }

  // MARK: - API

  /**
   This method get the current token or fetch a new one if needed.
   */
  func fetchToken() -> Observable<String> {
    return currentToken.asObservable()
      .flatMap { token -> Observable<String> in
        if let token = token {
          return Observable.just(token)
        } else {
          let fetcher = self.currentFetcher ?? self.sharedTokenRequest()
          self.currentFetcher = fetcher
          return fetcher
        }
      }
      .take(1) // Send .completed after the first .next received from inside the flatMap (because the .completed from inside the flatMap doesn't propagate ouside the flatMap)
  }

  func invalidateToken() {
    self.currentToken.value = nil
  }

  // MARK: - Private helpers

  /**
   To get a new token, we using a shared observable. This way, only one fetch token request is made.
   And all the observer was notified
   */
  private func sharedTokenRequest() -> Observable<String> {
    return tokenFetcher
      .do(onNext: { [unowned self] token in
        self.currentToken.value = token
      })
      .share()
  }

}
