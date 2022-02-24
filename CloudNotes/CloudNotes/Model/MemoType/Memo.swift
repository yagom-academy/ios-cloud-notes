import Foundation

struct Memo: Codable, MemoType {
     var title: String?
     var body: String?
     var lastModified: Date?
     var identifier: UUID?

     enum CodingKeys: String, CodingKey {
         case title, body
         case lastModified = "last_modified"
     }
 }
