import CoreData
import SwiftyDropbox

class CloudDataManager {
    
    private var fileManager: FileManager {
        FileManager.default
    }
    private var sqliteURL: URL {
        NSPersistentContainer.defaultDirectoryURL()
    }
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
        
        result.forEach { url in
            guard let filename = url.path.split(separator: "/").last else {
                return
            }
            guard let data = fileManager.contents(atPath: url.path) else {
                return
            }
            
            client?.files.upload(path: "/SYNCloudNotes/\(filename)", mode: .overwrite, autorename: true, input: data)
        }
    }
    
    func downloadDB() {
        ["CloudNotes.sqlite", "CloudNotes.sqlite-shm", "CloudNotes.sqlite-wal"].forEach { string in
            client?.files.download(path: "/SYNCloudNotes/\(string)", overwrite: true, destination: { url, _ in
                return url
            })
        }
    }
    
}
