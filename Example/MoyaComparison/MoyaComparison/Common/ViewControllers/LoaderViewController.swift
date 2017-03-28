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
import Reusable

protocol LoaderViewControllerActions: class {
  func didFinishLoad()
}

final class LoaderViewController: UIViewController, StoryboardBased {
  
  // MARK: - private properties
  private weak var actions: LoaderViewControllerActions?
  // MARK: - instance
  static func instance(actions: LoaderViewControllerActions) -> LoaderViewController {
    let controller = LoaderViewController.instantiate()
    controller.actions = actions
    return controller
  }
  
  // MARK: - Override Funcs
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    actions?.didFinishLoad()
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
