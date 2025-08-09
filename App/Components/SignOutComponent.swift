import HotwireNative
import UIKit

final class SignOutComponent: BridgeComponent {
  override class var name: String { "sign-out" }
  
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
      addButton(via: message)
    }
  }
  
  private func addButton(via message: Message) {
    guard let data: MessageData = message.data() else { return }
    let image = UIImage(systemName: data.image ?? "")
    let action = UIAction { [unowned self] _ in
      self.reply(to: message.event)
    }
    let item = UIBarButtonItem(title: data.title, image: image, primaryAction: action)
    viewController?.navigationItem.rightBarButtonItem = item
  }
}


private extension SignOutComponent{
  enum Event: String {
    case connect
  }
}

private extension SignOutComponent{
  struct MessageData: Decodable {
    let title: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
      case title
      case image = "iosImage"
    }
  }
}
