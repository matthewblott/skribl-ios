import HotwireNative
import UIKit

final class ShowTabBarComponent: BridgeComponent {
  override class var name: String { "show-tabbar" }
  
  private var window: UIWindow? {
    viewController?.view.window as? UIWindow
  }
  
  private var viewController: UIViewController? {
    delegate?.destination as? UIViewController
  }
  
  private var tabBarController: HotwireTabBarController? {
    viewController?.tabBarController as? HotwireTabBarController
  }
  
  override func onReceive(message: Message) {
    guard let event = Event(rawValue: message.event) else { return }
    switch event {
    case .connect:
      
      if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.switchToTabBar()
      }
      self.reply(to: message.event)
    }
  }
  
}

private extension ShowTabBarComponent{
  enum Event: String {
    case connect
  }
}

private extension ShowTabBarComponent{
  struct MessageData: Decodable {
    let title: String
  }
}

