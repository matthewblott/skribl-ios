import HotwireNative
import UIKit
import WebKit

class ViewController : HotwireWebViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.hidesBackButton = true
  }
}
