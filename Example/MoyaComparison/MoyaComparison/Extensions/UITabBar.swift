//
//  UITabBar.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 25/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import UIKit

extension UITabBar {
  func setupBlackTabBar() {
    self.barStyle = UIBarStyle.black
    self.barTintColor = ColorName.black.color
    self.isTranslucent = false
    self.tintColor = ColorName.greenBoardColor.color
  }
}
