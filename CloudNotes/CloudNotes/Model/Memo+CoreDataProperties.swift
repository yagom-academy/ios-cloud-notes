import UIKit.UIFont
import CoreData

enum NameSpace {
    static let bodyLimit = 40
}

extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String!
    @NSManaged public var body: String!
    @NSManaged public var lastModified: Date!
    @NSManaged public var id: UUID!

    var subtitle: NSAttributedString {
        let dateString = createFormattedDate()
        let truncatedBody = body.truncated(limit: NameSpace.bodyLimit)
        
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
    
    private func createFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: lastModified)
    }
}

extension Memo : Identifiable {

}
