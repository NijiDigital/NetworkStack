//
//  UIBarButtonFactory.swift
//  NetworkStackExample
//
//  Created by Steven_WATREMEZ on 26/03/2017.
//  Copyright © 2017 niji. All rights reserved.
//

import Foundation
import UIKit

final class BarButtonItemFactory: UIBarButtonItem {
  
  private var actionBlock:(() -> Void)?
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  convenience init(image: UIImage?, title: String, style: UIBarButtonItemStyle, action:(() -> Void)?) {
    self.init(style: style, action: action)
    self.title = title
    self.image = image
  }
  
  convenience init(image: UIImage?, style: UIBarButtonItemStyle, action:(() -> Void)?) {
    self.init(style: style, action: action)
    self.image = image
  }
  
  convenience init(title: String?, style: UIBarButtonItemStyle, action:(() -> Void)?) {
    self.init(style: style, action: action)
    self.title = title
  }
  
  private convenience init(style: UIBarButtonItemStyle, action:(() -> Void)?) {
    self.init()
    self.style = style
    self.target = self
    self.action = #selector(executeAction(sender:))
    self.actionBlock = action
  }
  
  @objc func executeAction(sender: BarButtonItemFactory) {
    if let actionBlock = self.actionBlock {
      actionBlock()
    }
  }
}
