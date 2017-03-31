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
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum LoaderViewController: String, StoryboardSceneType {
    static let storyboardName = "LoaderViewController"

    static func initialViewController() -> MoyaComparison.LoaderViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? MoyaComparison.LoaderViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case loaderViewControllerScene = "LoaderViewController"
    static func instantiateLoaderViewController() -> MoyaComparison.LoaderViewController {
      guard let vc = StoryboardScene.LoaderViewController.loaderViewControllerScene.viewController() as? MoyaComparison.LoaderViewController
      else {
        fatalError("ViewController 'LoaderViewController' is not of the expected class MoyaComparison.LoaderViewController.")
      }
      return vc
    }
  }
  enum LoginViewController: String, StoryboardSceneType {
    static let storyboardName = "LoginViewController"

    static func initialViewController() -> MoyaComparison.LoginViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? MoyaComparison.LoginViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case loginViewControllerScene = "LoginViewController"
    static func instantiateLoginViewController() -> MoyaComparison.LoginViewController {
      guard let vc = StoryboardScene.LoginViewController.loginViewControllerScene.viewController() as? MoyaComparison.LoginViewController
      else {
        fatalError("ViewController 'LoginViewController' is not of the expected class MoyaComparison.LoginViewController.")
      }
      return vc
    }
  }
  enum Main: StoryboardSceneType {
    static let storyboardName = "Main"
  }
  enum VideosViewController: String, StoryboardSceneType {
    static let storyboardName = "VideosViewController"

    static func initialViewController() -> MoyaComparison.VideosViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? MoyaComparison.VideosViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case videosViewControllerScene = "VideosViewController"
    static func instantiateVideosViewController() -> MoyaComparison.VideosViewController {
      guard let vc = StoryboardScene.VideosViewController.videosViewControllerScene.viewController() as? MoyaComparison.VideosViewController
      else {
        fatalError("ViewController 'VideosViewController' is not of the expected class MoyaComparison.VideosViewController.")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
}

private final class BundleToken {}
