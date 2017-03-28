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

// MARK: BaseViewController extension
extension UIViewController {
  
  var stringName: String {
    return NSStringFromClass(self.classForCoder)
  }
  
  func isVisible() -> Bool {
    let isVisible = self.isViewLoaded && self.view.window != nil
    return isVisible
  }
  
  func removeFromContainer() {
    willMove(toParentViewController: nil)
    view.removeFromSuperview()
    removeFromParentViewController()
  }
  
  func addInContainer(_ containerViewController: UIViewController) {
    addInContainer(containerViewController, inView: containerViewController.view)
  }
  
  func addInContainer(_ containerViewController: UIViewController, inView contentView: UIView) {
    containerViewController.addChildViewController(self)
    view.frame = contentView.bounds
    contentView.embedView(view)
    didMove(toParentViewController: containerViewController)
  }
  
  func sa_addChildViewController(viewController: UIViewController) {
    self.sa_addChildViewController(viewController: viewController, onView: self.view)
  }
  
  func sa_addChildViewController(viewController: UIViewController, onView view: UIView) {
    self.addChildViewController(viewController)
    viewController.view.frame = view.bounds
    view.embedView(viewController.view)
    viewController.didMove(toParentViewController: self)
  }
  
  func sa_removeChildViewController(viewController: UIViewController) {
    viewController.willMove(toParentViewController: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParentViewController()
  }
  
  @objc func sa_dismiss() {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
