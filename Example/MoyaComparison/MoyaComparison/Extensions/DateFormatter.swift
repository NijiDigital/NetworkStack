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
import SwiftyJSON

extension DateFormatter {
  
  static private let webServiceIsoFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
  static private let webServiceIsoFormatWithUSLocal = "yyyy-MM-dd'T'HH:mm:ssXXX"
  static private let deviceListInputFormat = "yyyy-MM-dd HH:mm:ss"
  static private let deviceListOutputFormat = "dd/MM/yyyy"
  static private let playerSimpleDateFormat = "mm:ss"
  
  static private let accengageDateFormat = "yyyy-MM-dd HH:mm:ss zzz"
  
  @nonobjc static let webServiceIsoFormatter = DateFormatter(format: webServiceIsoFormat)
  @nonobjc static let deviceListInputFormatter = DateFormatter(format: deviceListInputFormat)
  @nonobjc static let deviceListOutputFormatter = DateFormatter(format: deviceListOutputFormat)
  @nonobjc static let playerSimpleDateFormatter = DateFormatter(format: playerSimpleDateFormat)
  
  @nonobjc static let accengageDateFormatter = DateFormatter(format: accengageDateFormat)
  
  @nonobjc static let iso8601Formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = webServiceIsoFormatWithUSLocal
    return formatter
  }()
  
  private convenience init(format: String) {
    self.init()
    dateFormat = format
  }
  
  static func dateTransform(value: String, json: JSON) -> Date? {
    let formatter = webServiceIsoFormatter
    return formatter.date(from: value)
  }
}
