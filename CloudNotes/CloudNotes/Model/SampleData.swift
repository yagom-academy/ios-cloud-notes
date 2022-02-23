import Foundation

struct SampleData: Decodable, MemoType {
     var title: String?
     var body: String?
     var lastModified: Date?

     enum CodingKeys: String, CodingKey {
         case title, body
         case lastModified = "last_modified"
     }
 }
