import HotwireNative
import UIKit

final class SignInSuccessComponent: BridgeComponent {
  override class var name: String { "sign-in-success" }
  
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
    case .authenticated:
      if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.selectNotesTab()
        sceneDelegate.switchToTabBar()
      }
      self.reply(to: message.event)
    }
  }

}

private extension SignInSuccessComponent{
  enum Event: String {
    case authenticated
  }
}

private extension SignInSuccessComponent{
  struct MessageData: Decodable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
      case value
    }
  }
}

