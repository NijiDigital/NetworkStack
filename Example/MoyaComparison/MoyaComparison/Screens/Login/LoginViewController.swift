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

final class LoginViewController: UIViewController, StoryboardBased {
  
  // MARK: - Private Properties
  private var webservice: WebServiceClient?
  
  // MARK: - Instance
  public static func instance(webService: WebServiceClient?) -> LoginViewController {
    let controller = LoginViewController.instantiate()
    controller.webservice = webService
    return controller
  }

  // MARK: - Override Funcs
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  override var prefersStatusBarHidden: Bool { return false }
}
