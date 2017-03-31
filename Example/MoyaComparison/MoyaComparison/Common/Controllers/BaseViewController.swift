//
// Copyright 2017 niji
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import RxSwift
import Reusable

enum BaseViewControllerMethod {
  case push, presentModal, presentModalWithNavigation, replaceRoot
}

class BaseViewController: UIViewController {
  
  // MARK: Properties
  weak var rootViewController: UIViewController?
  fileprivate(set) var isViewDidAppear: Bool = false
  
  // MARK: Overrides methods
  override var childViewControllerForStatusBarHidden: UIViewController? {
    return rootViewController
  }
  
  override var childViewControllerForStatusBarStyle: UIViewController? {
    return rootViewController
  }
  
  override var prefersStatusBarHidden: Bool { return false }
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  override var shouldAutorotate: Bool { return true }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return [.portrait, .landscape, .portraitUpsideDown] }
  
  // MARK: Public methods
  func addViewController(_ viewController: UIViewController, method: BaseViewControllerMethod) {
    
    switch method {
    case .push: self.push(viewController)
    case .presentModal: self.presentModal(viewController, withNavigation: false)
    case .replaceRoot: self.replaceRoot(viewController)
    case .presentModalWithNavigation: self.presentModal(viewController, withNavigation: true)
    }
  }
  
  // MARK: Privates methods
  fileprivate func push(_ viewController: UIViewController) {
    guard let unwrappedNavigationController = navigationController else { fatalError("Trying to push but no navigation controller is set") }
    unwrappedNavigationController.pushViewController(viewController, animated: true)
  }
  
  fileprivate func replaceRoot(_ viewController: UIViewController) {
    // Remove current viewController if exist
    if let unwrappedRootViewController = rootViewController {
      unwrappedRootViewController.dismiss(animated: false, completion: {})
      unwrappedRootViewController.removeFromContainer()
      rootViewController = nil
    }
    // Add new view controller
    viewController.addInContainer(self)
    rootViewController = viewController
  }
  
  fileprivate func presentModal(_ viewController: UIViewController, withNavigation navigation: Bool) {
    if navigation {
      let navigationController = UINavigationController(rootViewController: viewController)
      present(navigationController, animated: true, completion: nil)
    } else {
      viewController.modalPresentationStyle = .overCurrentContext
      present(viewController, animated: true, completion: nil)
    }
  }
  
  fileprivate func presentModalWithNavigation(_ viewController: UIViewController) -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: viewController)
    present(navigationController, animated: true, completion: nil)
    return navigationController
  }
  
  fileprivate func dismissModalStack() {
    self.dismiss(animated: true, completion: nil)
  }
}
