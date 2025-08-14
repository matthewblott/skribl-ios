import HotwireNative
import UIKit
import WebKit

final class SceneDelegate: UIResponder {
  var window: UIWindow?

  public lazy var tabBarController = TabBarController (
    navigatorDelegate: self
  )
  
  private let navigator = Navigator(
    configuration: .init(
      name: "unauthenticated-navigator",
      startLocation: Endpoint.baseURL
    )
  )
}

extension SceneDelegate {
  func switchToTabBar() {
//    window?.rootViewController = tabBarController
    
//    let nc = tabBarController.viewControllers?[1] as? UINavigationController
//    let webViewController = nc?.viewControllers.first as? HotwireWebViewController
    
    let url = Endpoint.baseURL.appending(path: "1/notes")
    
    let navigator = tabBarController.activeNavigator
//    let url = URL(string: "")
    navigator.route(url)
  }
   
  func switchToNavigator() {
//    window?.rootViewController = navigator.rootViewController
//    navigator.start()
  }
  
  func selectNotesTab() {
    self.tabBarController.selectedIndex = 0
  }
  
  func selectNewNoteTab() {
    self.tabBarController.selectedIndex = 1
  }
  
  func selectSettingsTab() {
    self.tabBarController.selectedIndex = 2
  }
  
  func changeTab() {
    let currentIndex = self.tabBarController.selectedIndex
    
    if currentIndex == 0 {
      self.tabBarController.selectedIndex = 1
    }
    else if currentIndex == 1 {
      self.tabBarController.selectedIndex = 2
    }
    else if currentIndex == 2 {
    }
    
  }
  
}

extension SceneDelegate: UIWindowSceneDelegate {
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    navigator.delegate = self
//    window?.rootViewController = navigator.rootViewController
//    navigator.start()
    tabBarController.load(Tabs.all)
    window?.rootViewController = tabBarController
  }

}

extension SceneDelegate: NavigatorDelegate {
  func handle(proposal: VisitProposal, from navigator: Navigator) -> ProposalResult {
    let webView = navigator.session.webView
    let targetURL = proposal.url
    
    if targetURL.path.contains("new") {
      webView.scrollView.bounces = false
      webView.scrollView.isScrollEnabled = false
    } else {
      webView.scrollView.bounces = true
      webView.scrollView.isScrollEnabled = true
    }
    
    return .accept
  }
  
}
