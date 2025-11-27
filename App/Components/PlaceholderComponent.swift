import HotwireNative
import UIKit

final class PlaceholderComponent: BridgeComponent {
  override class var name: String { "ios-placeholder" }
  
  private var viewController: UIViewController? {
    delegate?.destination as? UIViewController
  }
  
  override func onReceive(message: Message) {
    guard let event = Event(rawValue: message.event) else { return }
    switch event {
    case .connect:
      viewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(
        title: ""
      )
    }
  }
}


private extension PlaceholderComponent{
  enum Event: String {
    case connect
  }
}
