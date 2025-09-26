import HotwireNative
import UIKit

final class DeleteAccountComponent: BridgeComponent {
  override class var name: String { "delete-account" }
  
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
    case .submit:
      presentAlert(via: message)
    }
  }
 
  private func presentAlert(via message: Message) {
    guard let data: MessageData = message.data() else { return }
    
    let alert = UIAlertController(
      title: data.title,
      message: data.description,
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(
      title: data.confirm,
      style: data.confirmActionStyle
    ) { [unowned self] _ in
      reply(to: message.event)
    })
    
    alert.addAction(UIAlertAction(
      title: data.dismiss,
      style: .cancel
    ) { _ in })
    
    viewController?.present(alert, animated: true)
  }

}


private extension DeleteAccountComponent{
  enum Event: String {
    case submit
  }
}

private extension DeleteAccountComponent {
  struct MessageData: Decodable {
    let title: String
    let description: String?
    let destructive: Bool
    let confirm: String
    let dismiss: String
    
    var confirmActionStyle: UIAlertAction.Style { destructive ? .destructive : .default }
  }
}
