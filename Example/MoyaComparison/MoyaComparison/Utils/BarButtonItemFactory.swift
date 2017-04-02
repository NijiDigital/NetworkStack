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
