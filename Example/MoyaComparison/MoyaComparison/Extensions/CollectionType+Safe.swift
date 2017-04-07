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

// this extension allow us to use Array with safe access
public extension Collection {
  // MARK: - Public Funcs
  public subscript(safe index: Index) -> Iterator.Element? {
    if distance(to: index) >= 0 && distance(from: index) > 0 {
      return self[index]
    }
    return nil
  }
  
  public subscript(safe bounds: Range<Index>) -> SubSequence? {
    if distance(to: bounds.lowerBound) >= 0 && distance(from: bounds.upperBound) >= 0 {
      return self[bounds]
    }
    return nil
  }
  
  public subscript(safe bounds: ClosedRange<Index>) -> SubSequence? {
    if distance(to: bounds.lowerBound) >= 0 && distance(from: bounds.upperBound) > 0 {
      return self[bounds]
    }
    return nil
  }
  
  // MARK: - Private Funcs
  private func distance(from startIndex: Index) -> IndexDistance {
    return distance(from: startIndex, to: self.endIndex)
  }
  
  private func distance(to endIndex: Index) -> IndexDistance {
    return distance(from: self.startIndex, to: endIndex)
  }
}
