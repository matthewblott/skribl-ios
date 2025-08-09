import HotwireNative
import UIKit

enum Tabs {
  static let all: [HotwireTab] = [
    HotwireTab(
      title: "Home",
      image: UIImage(systemName: "person")!,
      url: Endpoint.baseURL.appending(path: "1/notes")
    ),
    HotwireTab(
      title: "Foo",
      image: UIImage(systemName: "person")!,
      url: Endpoint.baseURL.appending(path: "")
    ),
    HotwireTab(
      title: "Bar",
      image: UIImage(systemName: "person")!,
      url: Endpoint.baseURL.appending(path: "")
    ),
  ]
  
}
