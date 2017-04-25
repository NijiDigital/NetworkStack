//
//  ViewController.swift
//  NetworkStackDemo
//
//  Copyright © 2017 Niji. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import NetworkStack
import RxSwift

class ViewController: UIViewController {
  
  private let disposebag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let networkStack = NetworkStack(baseURL: "https://safe-retreat-51773.herokuapp.com/api/v1", keychainService: KeychainService(serviceType: "com.niji.networkstack"))
    let client = VideoWebServiceClient(networkStack: networkStack)
    
    client.fetchVideo(identifier: 0)
      .observeOn(MainScheduler.instance)
      .subscribe { (event: Event<Video>) in
        switch event {
        case .next(let video): print("video : \(video)")
        case .error(let error): print("!!!!!! error : \(error) !!! !!!")
        case .completed: print("completed !")
        }
      }.addDisposableTo(self.disposebag)
  }
}

