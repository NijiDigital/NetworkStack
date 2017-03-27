// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

enum StoryboardScene {
  enum ForthViewController: String, StoryboardSceneType {
    static let storyboardName = "ForthViewController"

    static func initialViewController() -> NetworkStackExample.ForthViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? NetworkStackExample.ForthViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case forthViewControllerScene = "ForthViewController"
    static func instantiateForthViewController() -> NetworkStackExample.ForthViewController {
      guard let vc = StoryboardScene.ForthViewController.forthViewControllerScene.viewController() as? NetworkStackExample.ForthViewController
      else {
        fatalError("ViewController 'ForthViewController' is not of the expected class NetworkStackExample.ForthViewController.")
      }
      return vc
    }
  }
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum LoaderViewController: String, StoryboardSceneType {
    static let storyboardName = "LoaderViewController"

    static func initialViewController() -> NetworkStackExample.LoaderViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? NetworkStackExample.LoaderViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case loaderViewControllerScene = "LoaderViewController"
    static func instantiateLoaderViewController() -> NetworkStackExample.LoaderViewController {
      guard let vc = StoryboardScene.LoaderViewController.loaderViewControllerScene.viewController() as? NetworkStackExample.LoaderViewController
      else {
        fatalError("ViewController 'LoaderViewController' is not of the expected class NetworkStackExample.LoaderViewController.")
      }
      return vc
    }
  }
  enum Main: StoryboardSceneType {
    static let storyboardName = "Main"
  }
  enum MoyaStackViewController: String, StoryboardSceneType {
    static let storyboardName = "MoyaStackViewController"

    static func initialViewController() -> NetworkStackExample.MoyaStackViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? NetworkStackExample.MoyaStackViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case moyaStackViewControllerScene = "MoyaStackViewController"
    static func instantiateMoyaStackViewController() -> NetworkStackExample.MoyaStackViewController {
      guard let vc = StoryboardScene.MoyaStackViewController.moyaStackViewControllerScene.viewController() as? NetworkStackExample.MoyaStackViewController
      else {
        fatalError("ViewController 'MoyaStackViewController' is not of the expected class NetworkStackExample.MoyaStackViewController.")
      }
      return vc
    }
  }
  enum NijiStackViewController: String, StoryboardSceneType {
    static let storyboardName = "NijiStackViewController"

    static func initialViewController() -> NetworkStackExample.NijiStackViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? NetworkStackExample.NijiStackViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case nijiStackViewControllerScene = "NijiStackViewController"
    static func instantiateNijiStackViewController() -> NetworkStackExample.NijiStackViewController {
      guard let vc = StoryboardScene.NijiStackViewController.nijiStackViewControllerScene.viewController() as? NetworkStackExample.NijiStackViewController
      else {
        fatalError("ViewController 'NijiStackViewController' is not of the expected class NetworkStackExample.NijiStackViewController.")
      }
      return vc
    }
  }
  enum ThirdViewController: String, StoryboardSceneType {
    static let storyboardName = "ThirdViewController"

    static func initialViewController() -> NetworkStackExample.ThirdViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? NetworkStackExample.ThirdViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case thirdViewControllerScene = "ThirdViewController"
    static func instantiateThirdViewController() -> NetworkStackExample.ThirdViewController {
      guard let vc = StoryboardScene.ThirdViewController.thirdViewControllerScene.viewController() as? NetworkStackExample.ThirdViewController
      else {
        fatalError("ViewController 'ThirdViewController' is not of the expected class NetworkStackExample.ThirdViewController.")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
}

private final class BundleToken {}
