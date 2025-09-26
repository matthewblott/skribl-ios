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
    // tabBarController.activeNavigator.clearAll()
    tabBarController.load(Tabs.all)
    window?.rootViewController = tabBarController
    
  }
  
  func switchToNavigator() {
    // navigator.clearAll(animated: false)  // Clear entire stack
    // navigator.route(Endpoint.baseURL)
    navigator.start()
    window?.rootViewController = navigator.rootViewController
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
    guard let url = URL(string: "http://localhost:3000/signed_in") else {
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
    } else {
      webView.scrollView.bounces = true
      webView.scrollView.isScrollEnabled = true
    }
    
    return .accept
  }
  
}
