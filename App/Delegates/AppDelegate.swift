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
      PlaceholderComponent.self,
      CancelDeleteComponent.self,
      SendOtpComponent.self,
      SignInComponent.self,
      SignInSuccessComponent.self,
      SignOutComponent.self,
      HideTabBarComponent.self,
      ShowTabBarComponent.self,
      ChangeTabComponent.self,
      ClearCanvasComponent.self,
      CreateNoteComponent.self,
      DeleteNoteComponent.self,
      DeleteAccountComponent.self,
      ToggleSelectionComponent.self,
      ToastComponent.self,
    ])
    
    let localPathConfigURL = Bundle.main.url(forResource: "path-configuration", withExtension: "json")!
  
    Hotwire.loadPathConfiguration(from: [
      .file(localPathConfigURL),
    ])

    Hotwire.config.makeCustomWebView = { config in
      config.websiteDataStore = WKWebsiteDataStore.default()
      let webView = WKWebView(frame: .zero, configuration: config)
     
      if #available(iOS 16.4, *) {
        webView.isInspectable = true
      }
      
      return webView
    }
    
    Hotwire.config.defaultViewController = { ViewController(url: $0) }
#if DEBUG
    Hotwire.config.debugLoggingEnabled = true
#endif
    Hotwire.config.applicationUserAgentPrefix = "Scribble;"

    return true
  }
  
  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

}
