//
//  UploadRequestParametersFile.swift
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

import Foundation

public struct UploadRequestParametersFile {
  public let fileURL: URL
  public let parameterName: String
  public let fileName: String
  public let mimeType: String
  
  public init(fileURL: URL,
              parameterName: String,
              fileName: String,
              mimeType: String) {
    self.fileURL = fileURL
    self.parameterName = parameterName
    self.fileName = fileName
    self.mimeType = mimeType
  }
  
  public init(fileURL: URL,
              parameterName: String,
              fileName: String) {
    self.init(fileURL: fileURL,
              parameterName: parameterName,
              fileName: fileName,
              mimeType: MimeTypeHelper.mimeType(forFileURL: fileURL))
  }
  
  public init(fileURL: URL, parameterName: String) {
    self.init(fileURL: fileURL,
              parameterName: parameterName,
              fileName: fileURL.lastPathComponent)
  }
}
