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
import Moya

extension CustomAPI {
  public var method: Moya.Method {
    switch self {
    case .getVideo, .getVideos:
      return .get
    case .putVideo:
      return .put
    case .postVideo, .uploadVideoDocument, .authent:
      return .post
    case .delVideo:
      return .delete
    }
  }
}
