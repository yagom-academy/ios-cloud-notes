import Foundation
import CoreData
import SwiftyDropbox

class CloudDataManager {
    
    private var sqliteURL: URL {
        NSPersistentContainer.defaultDirectoryURL()
    }
    
    private let fileManager = FileManager.default
    
    private var client: DropboxClient? {
        DropboxClientsManager.authorizedClient
    }
    
    func uploadDB() {
        guard let result = try? fileManager.contentsOfDirectory(
            at: sqliteURL,
            includingPropertiesForKeys: nil,
            options: .includesDirectoriesPostOrder
        ) else {
            return
        }
        
        guard let path = result.filter({ $0.path.hasSuffix("sqlite") }).first else {
            return
        }
        guard let filename = path.path.split(separator: "/").last else {
            return
        }
        guard let data = fileManager.contents(atPath: path.path) else {
            return
        }
        
        client?.files.upload(path: "/SYNCloudNotes/\(filename)", input: data)
            .response(queue: DispatchQueue.global(qos: .background)) { response, error in
                if let response = response {
                    print(response)
                } else if let error = error {
                    print(error)
                }
            }
            .progress({ progressData in
                print(progressData)
            })
        
    }
    
}
