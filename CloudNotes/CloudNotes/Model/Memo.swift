import UIKit.UIFont

struct Memo: Decodable {
  let title: String
  let body: String
  let lastModified: Date
}

extension Memo {
  var subtitle: NSAttributedString {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy. MM. dd. "
    let dateString = dateFormatter.string(from: lastModified)
    let truncatedBody = body.truncated(limit: 100)
    
    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(
      string: dateString,
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

private extension String {
  func truncated(limit: Int) -> String {
    if self.count > limit {
      let endIndex = self.index(self.startIndex, offsetBy: limit)
      return String(self[...endIndex])
    }
    return self
  }
}
