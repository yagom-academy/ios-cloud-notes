import UIKit.UIFont

struct Memo: Decodable {
  let id = UUID()
  var title: String
  var body: String
  var lastModified: Date
  
  enum CodingKeys: CodingKey {
    case title, body, lastModified
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

extension Memo: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Memo: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}
