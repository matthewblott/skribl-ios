import HotwireNative
import UIKit

enum Tabs {
  static let all: [HotwireTab] = [
    HotwireTab(
      title: "Notes",
      image: UIImage(named: "Notes")!,
      url: Endpoint.baseURL!.appending(path: "\(Settings.userId)/notes")
    ),
    HotwireTab(
      title: "New Note",
      image: UIImage(named: "Note")!,
      url: Endpoint.baseURL!.appending(path: "\(Settings.userId)/notes/new")
    ),
    HotwireTab(
      title: "Settings",
      image: UIImage(systemName: "gearshape.fill")!,
      url: Endpoint.baseURL!.appending(path: "settings")
    ),
  ]
  
}
