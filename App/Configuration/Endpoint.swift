import UIKit

struct Endpoint {
  static let remote: URL? = URL(string: "https://scribble.coderscoffeehouse.com")!
  static let local: URL? = URL(string: "http://localhost:3000")!
//  static let local: URL? = URL(string: "https://canniest-colt-undeeply.ngrok-free.dev")!

  static var baseURL: URL? {
    local
  }
}
