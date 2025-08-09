import UIKit

struct Endpoint {
  static let remote = URL(string: "https://example.com")!
  static let local = URL(string: "http://localhost:3000")!
  
  static var baseURL: URL {
    local
  }
}
