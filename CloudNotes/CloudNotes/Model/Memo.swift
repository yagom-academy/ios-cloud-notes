import UIKit.UIFont

struct Memo {
  let title: String
  let body: String
  let lastModified: Date
}

extension Memo {
  var subTitle: NSAttributedString {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy. MM. dd. "
    let dateString = dateFormatter.string(from: lastModified)
    
    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(string: dateString, attributes: [.font: UIFont.preferredFont(forTextStyle: .footnote)]))
    attributedString.append(NSAttributedString(string: body, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1), .foregroundColor : UIColor.secondaryLabel]))
    return attributedString
  }
}
