import HotwireNative
import UIKit
import WebKit

final class DownloadComponent: BridgeComponent {
  override class var name: String { "download" }
  
  private var window: UIWindow? {
    viewController?.view.window as? UIWindow
  }
  
  var currentWebView: WKWebView? {
    (viewController as? VisitableViewController)?.visitableView.webView
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
    case .download:
      guard let data: MessageData = message.data() else { return }
      syncCookiesAndDownload(csrfToken: data.token)
    }
  }
  
  private func syncCookiesAndDownload(csrfToken: String) {
    guard let webView = currentWebView else {
      assertionFailure("No webView available")
      return
    }
    
    webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
      cookies.forEach {
        HTTPCookieStorage.shared.setCookie($0)
      }
      
      self.download(csrfToken: csrfToken)
    }
  }
  
  func download(csrfToken: String) {
    
    HTTPCookieStorage.shared.cookies?.forEach {
      print("Cookie:", $0.name, $0.domain)
    }
    
    let config = URLSessionConfiguration.default
    
    config.httpCookieStorage = HTTPCookieStorage.shared
    config.httpShouldSetCookies = true
    config.httpCookieAcceptPolicy = .always
    
    let session = URLSession(configuration: config)
    let url = Endpoint.baseURL!.appending(path: "download_images")
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    
    let body = "authenticity_token=\(csrfToken)"
    request.httpBody = body.data(using: .utf8)
    request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-Token")
    request.setValue(
      "application/x-www-form-urlencoded",
      forHTTPHeaderField: "Content-Type"
    )
    
    let task = session.downloadTask(with: request) { tempURL, response, error in
      if let error = error {
        print("❌ URLSession error:", error)
      }
      
      if let response = response as? HTTPURLResponse {
        print("ℹ️ Status:", response.statusCode)
        print("ℹ️ Headers:", response.allHeaderFields)
      } else {
        print("❌ Response is not HTTPURLResponse:", response as Any)
      }
      
      if let tempURL = tempURL {
        print("ℹ️ Temp file exists:", FileManager.default.fileExists(atPath: tempURL.path))
        print("ℹ️ Temp URL:", tempURL)
      } else {
        print("❌ tempURL is nil")
      }
      
      guard
        let tempURL = tempURL,
        let http = response as? HTTPURLResponse,
        http.statusCode == 200
      else {
        print("❌ Guard failed")
        return
      }
      
      do {
        let documents = try FileManager.default.url(
          for: .documentDirectory,
          in: .userDomainMask,
          appropriateFor: nil,
          create: false
        )

        let fileManager = FileManager.default
        let destination = documents
          .appendingPathComponent("Scribbles")
          .appendingPathExtension("zip")

        // Remove existing file if needed
        if fileManager.fileExists(atPath: destination.path) {
          try fileManager.removeItem(at: destination)
        }

        try FileManager.default.moveItem(at: tempURL, to: destination)

        DispatchQueue.main.async {
          self.presentSavePicker(for: destination)
        }

        print("Saved to:", destination)
      } catch {
        print("File error:", error)
      }
    }
    
    task.resume()
  }
  
  func presentSavePicker(for fileURL: URL) {
    let picker = UIDocumentPickerViewController(
      forExporting: [fileURL],
      asCopy: true
    )
    
    picker.modalPresentationStyle = .formSheet
    viewController?.present(picker, animated: true)
  }
  
}

private extension DownloadComponent{
  enum Event: String {
    case download
  }
}

private extension DownloadComponent {
  struct MessageData: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
      case token
    }
  }
}
