//
//  NavCoordinator.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 01/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import UIKit

protocol NavCoordinator: Coordinator {
  var navigationController: UINavigationController { get }
}

// MARK: - Default Implementation
extension NavCoordinator {
  var navigationController: UINavigationController {
    guard let nc = self.mainViewController as? UINavigationController else {
      fatalError("The rootViewController should be a UINavigationController")
    }
    return nc
  }
  
  func pushToRoot(viewController: UIViewController) {
    self.navigationController.setViewControllers([viewController], animated: false)
  }
  
  func push(viewController: UIViewController) {
    self.navigationController.pushViewController(viewController, animated: true)
  }
}
