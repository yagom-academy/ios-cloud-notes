import UIKit.UIFont

struct Memo: Decodable {
    var title: String
    var body: String
    var lastModified: Date
}

extension Memo {
    var subtitle: NSAttributedString {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .medium
        
        let dateString = dateFormatter.string(from: lastModified)
        let truncatedBody = body.truncated(limit: 40)
        
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
