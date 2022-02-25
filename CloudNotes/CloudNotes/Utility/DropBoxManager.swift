import Foundation
import SwiftyDropbox
import CoreData

struct DropBoxManager {
    private let dropBoxClient = DropboxClientsManager.authorizedClient
    private let fileNames = ["CloudNotes.sqlite", "CloudNotes.sqlite-shm", "CloudNotes.sqlite-wal"]
    private let filePath = "/test/path/in/Dropbox"
    
    func presentSafariViewController(controller: UIViewController) {
        let scopeRequest = ScopeRequest(
            scopeType: .user,
            scopes: ["account_info.read", "files.metadata.read", "files.content.write", "files.content.read"],
            includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: controller,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    func createFolderAtDropBox() {
        dropBoxClient?.files.createFolderV2(path: filePath).response { response, error in
            if let response = response {
                print(response)
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func uploadToDropBox() {
        fileNames.forEach { fileName in
            let fileURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(fileName)
            
            guard let data = FileManager.default.contents(atPath: fileURL.path) else {
                return
            }
            
            dropBoxClient?.files.upload(path: "\(filePath)/\(fileName)", mode: .overwrite, input: data)
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
    
    func downloadFromDropBox(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        fileNames.forEach { fileName in
            let fileURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(fileName)
            
            let destination: (URL, HTTPURLResponse) -> URL = { _, _ in
                return fileURL
            }
            group.enter()
            dropBoxClient?.files.download(path: "\(filePath)/\(fileName)", overwrite: true, destination: destination)
                .response(queue: .main) { response, error in
                    if let response = response {
                        print(response)
                    } else if let error = error {
                        print(error)
                    }
                    group.leave()
                }
                .progress { progressData in
                    print(progressData)
                }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
}
