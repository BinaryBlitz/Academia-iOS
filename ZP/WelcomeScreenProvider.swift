import Foundation

@objc class WelcomeScreenProvider: NSObject {

  static var sharedProvider = WelcomeScreenProvider()

  var imageURLString: String?
  var imageURL: URL? {
    return URL(string: (imageURLString ?? ""))
  }
  var hasAvailableScreen: Bool {
    return imageURLString != nil
  }
}
