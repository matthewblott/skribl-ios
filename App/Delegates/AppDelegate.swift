import HotwireNative
import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Hotwire.registerBridgeComponents([
      TestComponent.self,
      SignInComponent.self,
      SignOutComponent.self,
      HideTabBarComponent.self,
      ShowTabBarComponent.self,
      ChangeTabComponent.self,
      CreateNoteComponent.self,
      DeleteNoteComponent.self,
      DeleteAccountComponent.self,
    ])
    
    let localPathConfigURL = Bundle.main.url(forResource: "path-configuration", withExtension: "json")!
    
    let remotePathConfigURL = URL(
      string: "\(Endpoint.baseURL)/configurations/ios_v1.json"
    )!
   
    Hotwire.loadPathConfiguration(from: [
      .file(localPathConfigURL),
      .server(remotePathConfigURL)
    ])
      
    Hotwire.config.defaultViewController = { ViewController(url: $0) }
    
//    Hotwire.config.makeCustomWebView = { url in
//      let webView = WKWebView()
//      webView.scrollView.bounces = false
//      webView.scrollView.isScrollEnabled = false
//      return webView
//    }
    
    return true
  }
  
  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }

}
