import UIKit.UIFont
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
  public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity: entity, insertInto: context)
    self.id = UUID()
    self.lastModified = Date()
  }
}

extension Memo {
  var subtitle: NSAttributedString {
    let attributedString = NSMutableAttributedString()
    
    if let lastModified = lastModified {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = .current
      dateFormatter.dateStyle = .medium
      dateFormatter.timeStyle = .none
      let dateString = dateFormatter.string(from: lastModified)
      
      attributedString.append(NSAttributedString(
        string: dateString + " ",
        attributes: [.font: UIFont.preferredFont(forTextStyle: .footnote)]
      ))
    }
    let truncatedBody = body?.truncated(limit: 100) ?? ""
    
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
