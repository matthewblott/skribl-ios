import HotwireNative
import UIKit

final class ToggleSelectionComponent: BridgeComponent {
  override class var name: String { "toggle-selection" }
  
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

    var item: UIBarButtonItem!

    let action = UIAction { [unowned self] _ in
      item.isEnabled = false
      struct ReplyData: Encodable {
        let info: String
        let clicked: Bool
      }
      
      let replyData = ReplyData(info: "user tapped native button 1", clicked: true)
      let replyMessage = message.replacing(data: replyData)
      self.reply(with: replyMessage)
    }
    
    let title = data.title
    
    item = UIBarButtonItem(title: title, primaryAction: action)
    item.isEnabled = data.enabled
    
    viewController?.navigationItem.leftBarButtonItem = item
  }

  private func updateButton(via message: Message) {
    guard let data: MessageData = message.data() else { return }
    
    viewController?.navigationItem.leftBarButtonItem?.title = data.title
    viewController?.navigationItem.leftBarButtonItem?.isEnabled = data.enabled
    
//    var item: UIBarButtonItem!
//    
//    let action = UIAction { [unowned self] _ in
//      item.isEnabled = false
//      struct ReplyData: Encodable {
//        let info: String
//        let clicked: Bool
//      }
//      
//      let replyData = ReplyData(info: "user tapped native button 2", clicked: true)
//      let replyMessage = message.replacing(data: replyData)
//      self.reply(with: replyMessage)
//    }
    
//    let title = data.title
//    
//    item = UIBarButtonItem(title: title, primaryAction: action)
//    item.isEnabled = data.enabled
//    
//    viewController?.navigationItem.leftBarButtonItem = item
  }
  
}

private extension ToggleSelectionComponent{
  enum Event: String {
    case connect
    case update
  }
}

private extension ToggleSelectionComponent {
  struct MessageData: Decodable {
    let title: String
    let enabled: Bool
    
    enum CodingKeys: String, CodingKey {
      case title
      case enabled
    }
  }
}
