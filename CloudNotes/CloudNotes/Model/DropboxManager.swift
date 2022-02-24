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
    
    func authorize(viewController: UIViewController) {
        let scopes = [
            "account_info.read",
            "account_info.write",
            "files.content.read",
            "files.content.write",
            "files.metadata.read",
            "files.metadata.write"
        ]
        
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: scopes, includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    func upload(errorHandler: @escaping ([String]) -> Void) {
        guard let client = DropboxClientsManager.authorizedClient else {
            print("No client")
            return
        }
        let group = DispatchGroup()
        var errorMessages: [String] = []
        
        Self.sqliteFileNames.forEach {
            group.enter()
            let coreDataPath = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent($0)
            guard let data = FileManager.default.contents(atPath: coreDataPath.path) else {
                errorMessages.append("파일 경로가 올바르지 않습니다.")
                return
            }
            client.files.upload(path: "\(Self.basePath)\($0)", mode: .overwrite, input: data)
                .response { _, error in
                    if let error = error {
                        errorMessages.append(error.description)
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            if errorMessages.isEmpty == false {
                errorHandler(errorMessages)
            }
        }
    }
    
    func download(completion: @escaping () -> Void, errorHandler: @escaping ([String]) -> Void) {
        guard let client = DropboxClientsManager.authorizedClient else {
            print("No client")
            return
        }
        let group = DispatchGroup()
        var errorMessages: [String] = []
        
        Self.sqliteFileNames.forEach {
            group.enter()
            let coreDataPath = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent($0)
            let destination: (URL, HTTPURLResponse) -> URL = { _, _ in
                return coreDataPath
            }
            client.files.download(path: "\(Self.basePath)\($0)", overwrite: true, destination: destination)
                .response(queue: .main) { _, error in
                    if let error = error {
                        errorMessages.append(error.description)
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            if errorMessages.isEmpty == false {
                errorHandler(errorMessages)
            } else {
                completion()
            }
        }
    }
}
