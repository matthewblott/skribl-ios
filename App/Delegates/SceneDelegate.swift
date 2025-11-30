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
      startLocation: Endpoint.baseURL!
    )
  )
}

extension SceneDelegate {
  func switchToTabBar() {
    tabBarController.load(Tabs.all)
    
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    
    // Remove top border
    appearance.shadowImage = UIImage()
    appearance.shadowColor = .clear
    
    // Optional: keep your white background
    appearance.backgroundColor = .white
    
    tabBarController.tabBar.standardAppearance = appearance
    tabBarController.tabBar.scrollEdgeAppearance = appearance
    
    window?.rootViewController = tabBarController
  }
  
  func clear() {
    navigator.clearAll(animated: false)
  }
  
  func switchToNavigator() {
    navigator.start()
    window?.rootViewController = navigator.rootViewController
    navigator.session.webView.reload()
  }
  
  func setToRoot() {
    if let url = Endpoint.baseURL {
      navigator.route(url)
    }
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

  func checkUserAuthentication() async -> Bool {
    guard let url = Endpoint.baseURL?.appendingPathComponent("/signed_in") else {
      return false
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      
      if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
        let signedIn = json["signed_in"] as? Bool {
        return signedIn
      }
      return false
    } catch {
      print("JSON parsing error: \(error)")
      return false
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
    
    // If the user is signed in then execute switchToTabBar
    Task {
      let signedIn = await checkUserAuthentication()
      await MainActor.run {
        if signedIn {
          self.switchToTabBar()
        }
        else {
          self.switchToNavigator()
        }
      }
    }
  }

}

extension SceneDelegate: NavigatorDelegate {
  func handle(proposal: VisitProposal, from navigator: Navigator) -> ProposalResult {
    let webView = navigator.session.webView
    let targetURL = proposal.url
    
    if targetURL.path.contains("new") {
      webView.scrollView.bounces = false
      webView.scrollView.isScrollEnabled = false
      
      // Adjust insets after a brief delay to ensure safe areas are calculated
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        let bottomInset = webView.safeAreaInsets.bottom
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
      }
    } else {
      webView.scrollView.bounces = true
      webView.scrollView.isScrollEnabled = true
      webView.scrollView.contentInset = .zero
    }
    
    return .accept
  }

}
