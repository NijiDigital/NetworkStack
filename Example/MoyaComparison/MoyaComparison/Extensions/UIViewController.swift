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

// MARK: Back title
extension UIViewController {
  
  func removeBackTitle() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}

extension UIViewController {
  
  func setupNavigationItems() {
    self.navigationController?.navigationBar.backIndicatorImage = Asset.arrowLeft.image
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = Asset.arrowLeft.image
    
    let backItem = UIBarButtonItem(image: Asset.arrowLeft.image, style:.plain, target:self, action:nil)
    backItem.tintColor = UIColor.white
    self.navigationItem.backBarButtonItem = backItem
    self.parent?.navigationItem.backBarButtonItem = backItem
  }
  
  func setupRightNavigationItems(image: UIImage? = nil, title: String? = nil, color: UIColor, completion: @escaping () -> Void) {
    let barButtonItem = BlockBarButtonItem(image: image, title: title, style:.plain, action: completion)
    barButtonItem.tintColor = color
    self.navigationItem.rightBarButtonItem = barButtonItem
    self.parent?.navigationItem.rightBarButtonItem = barButtonItem
  }
  
  func setupLeftNavigationItems(image: UIImage? = nil, title: String? = nil, color: UIColor, completion: @escaping () -> Void) {
    let leftButtonItem = BlockBarButtonItem(image: image, title: title, style:.plain, action: completion)
    leftButtonItem.tintColor = color
    self.navigationItem.leftBarButtonItem = leftButtonItem
    self.parent?.navigationItem.leftBarButtonItem = leftButtonItem
  }
}
