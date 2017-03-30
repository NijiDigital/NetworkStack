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
  
  // MARK: - Private Properties
  private var actionBlock:(() -> Void)?
  
  // MARK: - Override Funcs
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Convenience Funcs
  convenience init(image: UIImage?, title: String?, style: UIBarButtonItemStyle, action:(() -> Void)?) {
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
  
  // MARK: - Actions
  @objc func executeAction(sender: BarButtonItemFactory) {
    if let actionBlock = self.actionBlock {
      actionBlock()
    }
  }
  
  // MARK: - Private Funcs
  private convenience init(style: UIBarButtonItemStyle, action:(() -> Void)?) {
    self.init()
    self.style = style
    self.target = self
    self.action = #selector(executeAction(sender:))
    self.actionBlock = action
  }
}
