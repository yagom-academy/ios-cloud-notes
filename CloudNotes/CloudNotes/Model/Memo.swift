import UIKit.UIFont

class Memo: Decodable {
  var title: String
  var body: String
  var lastModified: Date

  init(title: String, body: String, lastModified: Date) {
    self.title = title
    self.body = body
    self.lastModified = lastModified
  }
}

extension Memo {
  var subtitle: NSAttributedString {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    let dateString = dateFormatter.string(from: lastModified)
    let truncatedBody = body.truncated(limit: 100)
    
    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(
      string: dateString + " ",
      attributes: [.font: UIFont.preferredFont(forTextStyle: .footnote)]
    ))
    attributedString.append(NSAttributedString(
      string: truncatedBody,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor.secondaryLabel
      ]
    ))
    return attributedString
  }
}
