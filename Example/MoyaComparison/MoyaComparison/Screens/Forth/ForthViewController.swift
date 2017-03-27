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

final class ForthViewController: UIViewController, StoryboardBased {
  
  // MARK: private properties
  private var webservice: WebServiceClient?
  
  // MARK: instance
  public static func instance(webService: WebServiceClient?) -> ForthViewController {
    let controller = ForthViewController.instantiate()
    controller.webservice = webService
    return controller
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
}
