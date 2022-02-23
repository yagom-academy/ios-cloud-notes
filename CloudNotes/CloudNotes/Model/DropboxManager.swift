import Foundation
import CoreData
import SwiftyDropbox

struct DropboxManager {
    static var isAuthorized = false
    static let basePath = "/test/path/in/Dropbox/account"
    static let sqliteFileNames = [
        "/CloudNotes.sqlite",
        "/CloudNotes.sqlite-shm",
        "/CloudNotes.sqlite-wal"
    ]

    func upload() {
        guard let client = DropboxClientsManager.authorizedClient else {
            print("No client")
            return
        }
        
        Self.sqliteFileNames.forEach {
            let coreDataPath = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent($0)
            let data = FileManager.default.contents(atPath: coreDataPath.path)!
            _ = client.files.upload(path: "\(Self.basePath)\($0)", input: data)
                .response { response, error in
                    if let response = response {
                        print(response)
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print(progressData)
                }
        }
    }
    
    func download(completion: @escaping () -> Void) {
        guard let client = DropboxClientsManager.authorizedClient else {
            print("No client")
            return
        }
        let group = DispatchGroup()
        var errorFlag = false
        
        Self.sqliteFileNames.forEach {
            group.enter()
            let coreDataPath = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent($0)
            let destination: (URL, HTTPURLResponse) -> URL = { _, _ in
                return coreDataPath
            }
            client.files.download(path: "\(Self.basePath)\($0)", overwrite: true, destination: destination)
                .response(queue: .main) { _, error in
                    if let error = error {
                        print(error)
                        errorFlag = true
                    }
                    group.leave()
                }
                .progress { progressData in
                    print(progressData)
                }
        }
        
        group.notify(queue: .main) {
            if errorFlag == false {
                completion()
            }
        }
    }
}
