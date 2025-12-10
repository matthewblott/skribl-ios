import HotwireNative
import UIKit

final class CreateNoteComponent: BridgeComponent {
  override class var name: String { "create-note" }
  
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
    case .update:
      updateButton(via: message)
    }
  }

  private func addButton(via message: Message) {
    guard let data: MessageData = message.data() else { return }

    let action = UIAction { [unowned self] _ in
      self.reply(to: message.event)
    }
    
    let title = data.title
    let item = UIBarButtonItem(title: title, primaryAction: action)
    
    item.isEnabled = data.enabled
    
    viewController?.navigationItem.rightBarButtonItem = item
    
  }
  
  private func updateButton(via message: Message) {
    guard let data: MessageData = message.data() else { return }
    viewController?.navigationItem.rightBarButtonItem?.title = data.title
    viewController?.navigationItem.rightBarButtonItem?.isEnabled = data.enabled
  }
  
}


private extension CreateNoteComponent{
  enum Event: String {
    case connect
    case update
  }
}

private extension CreateNoteComponent{
  struct MessageData: Decodable {
    let title: String
    let enabled: Bool
    
    enum CodingKeys: String, CodingKey {
      case title
      case enabled
    }
  }
}
