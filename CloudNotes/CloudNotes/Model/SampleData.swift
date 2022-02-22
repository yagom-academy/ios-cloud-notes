import Foundation

struct SampleData: Decodable, MemoType {
     var title: String
     var body: String
     var lastModified: Int

     enum CodingKeys: String, CodingKey {
         case title, body
         case lastModified = "last_modified"
     }
 }
