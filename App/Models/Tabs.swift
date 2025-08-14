import HotwireNative
import UIKit

enum Tabs {
  static let all: [HotwireTab] = [
    HotwireTab(
      title: "Notes",
      image: UIImage(systemName: "person")!,
      url: Endpoint.baseURL.appending(path: "1/notes")
    ),
    HotwireTab(
      title: "New Note",
      image: UIImage(systemName: "person")!,
      url: Endpoint.baseURL.appending(path: "1/notes/new")
    ),
    HotwireTab(
      title: "Settings",
      image: UIImage(systemName: "person")!,
      url: Endpoint.baseURL.appending(path: "settings")
    ),
  ]
  
}
