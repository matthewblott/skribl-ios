import HotwireNative
import UIKit

enum Tabs {
  static let all: [HotwireTab] = [
    HotwireTab(
      title: "Scribbles",
      image: UIImage(named: "notes")!,
      url: Endpoint.baseURL!.appending(path: "${Settings}/notes")
    ),
    HotwireTab(
      title: "New Scribble",
      image: UIImage(named: "note-ios-2")!,
      url: Endpoint.baseURL!.appending(path: "1/notes/new")
    ),
    HotwireTab(
      title: "Settings",
      image: UIImage(systemName: "gearshape.fill")!,
      url: Endpoint.baseURL!.appending(path: "settings")
    ),
  ]
  
}
