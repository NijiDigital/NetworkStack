//
//  TabCoordinator.swift
//  MoyaComparison
//
//  Created by Steven_WATREMEZ on 01/04/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import UIKit

protocol TabCoordinator: Coordinator {
  var tabBarController: UITabBarController { get }
}

// MARK: - Default Implementation
extension TabCoordinator {
  var tabBarController: UITabBarController {
    guard let tabBarController = self.mainViewController as? UITabBarController else {
      fatalError("The rootViewController should be a UITabBarController")
    }
    return tabBarController
  }
}
