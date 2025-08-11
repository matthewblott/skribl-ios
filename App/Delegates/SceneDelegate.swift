import HotwireNative
import UIKit
import WebKit

final class SceneDelegate: UIResponder {
  var window: UIWindow?
  
  public lazy var tabBarController = HotwireTabBarController (
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
    tabBarController.load(Tabs.all)
    window?.rootViewController = tabBarController
  }
 
  func changeTab() {
    self.tabBarController.selectedIndex = 1
  }
  
  func switchToNavigator() {
    window?.rootViewController = navigator.rootViewController
    navigator.start()
  }
  
//  private func syncCookiesAndSwitch() {
//    let cookieStore = WKWebsiteDataStore.default().httpCookieStore
//    
//    // Get all cookies and ensure they're available
//    cookieStore.getAllCookies { [weak self] cookies in
//      DispatchQueue.main.async {
//        // Force cookie sync by setting them again
//        for cookie in cookies {
//          cookieStore.setCookie(cookie)
//        }
//        
//        self?.tabBarController.load(Tabs.all)
//        self?.window?.rootViewController = self?.tabBarController
//      }
//    }
//  }
}

extension SceneDelegate: UIWindowSceneDelegate {
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
//    guard let windowScene = (scene as? UIWindowScene) else { return }
//    window = UIWindow(windowScene: windowScene)
    navigator.delegate = self
//    window?.rootViewController = tabBarController
//    tabBarController.load(Tabs.all)
    window?.rootViewController = navigator.rootViewController
    navigator.start()
  }

}

extension SceneDelegate: NavigatorDelegate {
  func handle(proposal: VisitProposal, from navigator: Navigator) -> ProposalResult {
//  func handle(_ action: String, with options: [String : Any], in navigator: Navigator) -> ProposalResult {
    let webView = navigator.session.webView
//    let targetURL = visitable.visitableURL
    let targetURL = proposal.url
    // Ensure we actually have a URL loaded
//    if let currentURL = webView.url {
    if targetURL.path.contains("new") {
        // Only for canvas page
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
      } else {
        // Restore defaults for other pages if needed
        webView.scrollView.bounces = true
        webView.scrollView.isScrollEnabled = true
      }
//    }
    
    return .accept
  }
  
//  func navigator(_ navigator: Navigator, didPresentVisitable visitable: Visitable) {
//    guard let webView = visitable.visitableView.webView else { return }
//    
//    let currentURL = visitable.currentVisitableURL.absoluteString
//    
//    if shouldDisableScrolling(for: currentURL) {
//      webView.scrollView.bounces = false
//      webView.scrollView.isScrollEnabled = false
//    } else {
//      webView.scrollView.bounces = true
//      webView.scrollView.isScrollEnabled = true
//    }
//  }
  
//  private func shouldDisableScrolling(for url: String) -> Bool {
//    return url.contains("new") ||
//    url.contains("/draw") ||
//    url.contains("/sketch")
//  }
}
