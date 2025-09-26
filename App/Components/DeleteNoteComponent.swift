import HotwireNative
import UIKit

final class DeleteNoteComponent: BridgeComponent {
  override class var name: String { "delete-note" }
  
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
      presentAlert(via: message)
    }
    let item = UIBarButtonItem(title: data.title, image: image, primaryAction: action)
    viewController?.navigationItem.rightBarButtonItem = item
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

private extension DeleteNoteComponent{
  enum Event: String {
    case connect
  }
}

private extension DeleteNoteComponent {
  struct MessageData: Decodable {
    let title: String
    let description: String?
    let destructive: Bool
    let confirm: String
    let dismiss: String
    let image: String?

    enum CodingKeys: String, CodingKey {
      case title
      case description
      case destructive
      case confirm
      case dismiss
      case image = "iosImage"
    }
    var confirmActionStyle: UIAlertAction.Style { destructive ? .destructive : .default }

  }
}
