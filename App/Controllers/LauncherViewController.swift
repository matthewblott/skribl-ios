import HotwireNative
import UIKit

class LauncherViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    checkAuthenticationStatus()
  }
  
  private func checkAuthenticationStatus() {
    //    if isUserSignedIn() {
    navigateToMainApp()
    //    } else {
    //      navigateToSignIn()
    //    }
  }
  
  private func navigateToMainApp() {
    //    let mainVC = MainViewController()
    //    let mainVC = NewMainViewController(navigatorDelegate: navigatorDelegate)
    //    let navigatorDelegate = NewSceneDelegate()
    
    lazy var mainVC = HotwireTabBarController(
      //      navigatorDelegate: navigatorDelegate
    )
//    mainVC.load(HotwireTab.all)
    replaceRootViewController(with: mainVC)
  }
  
  private func navigateToSignIn() {
    //    let signInVC = SignInViewController()
    //    replaceRootViewController(with: signInVC)
  }
  
  private func replaceRootViewController(with viewController: UIViewController) {
    guard let window = view.window else { return }
    window.rootViewController = viewController
  }
  
  private func isUserSignedIn() -> Bool {
    return true
  }
}

