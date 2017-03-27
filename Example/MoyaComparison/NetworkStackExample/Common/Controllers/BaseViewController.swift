//
//  BaseViewController.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 3/12/17
//  Copyright (c) 2017 niji. All rights reserved.
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
  
  override var prefersStatusBarHidden: Bool { return true }
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
  
  // MARK: -
  // MARK: View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.isViewDidAppear = true
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
      _ = viewController.preferredStatusBarStyle
      let navigationController = UINavigationController(rootViewController: viewController)
      present(navigationController, animated: true, completion: nil)
    } else {
      viewController.modalPresentationStyle = .overCurrentContext
      present(viewController, animated: true, completion: nil)
    }
  }
  
  fileprivate func presentModalWithNavigation(_ viewController: UIViewController) -> UINavigationController {
    _ = viewController.preferredStatusBarStyle
    let navigationController = UINavigationController(rootViewController: viewController)
    present(navigationController, animated: true, completion: nil)
    return navigationController
  }
  
  fileprivate func dismissModalStack() {
    self.dismiss(animated: true, completion: nil)
  }
    
  fileprivate func topModalController(_ fromController: UIViewController) -> UIViewController {
    var topController = fromController
    if let nextController = fromController.presentedViewController {
      topController = self.topModalController(nextController)
    }
    return topController
  }
}
