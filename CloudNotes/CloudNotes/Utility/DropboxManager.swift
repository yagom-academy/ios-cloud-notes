import SwiftyDropbox
import UIKit

struct DropboxManager {
    private let client = DropboxClientsManager.authorizedClient
    private let applicationSupportDirectoryURL = FileManager.default.urls(
        for: .applicationSupportDirectory,
        in: .userDomainMask
    )[.zero]
    private let fileNames: [String] = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-shm", "/CloudNotes.sqlite-wal"]
    private let scopes = [
        "account_info.read",
        "account_info.write",
        "files.content.read",
        "files.content.write",
        "files.metadata.read",
        "files.metadata.write"
    ]
    
    func authorize(_ viewController: UIViewController) {
        let scopeRequest = ScopeRequest(
            scopeType: .user,
            scopes: scopes,
            includeGrantedScopes: false
        )
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { url in
                UIApplication.shared.open(url, options: [:])
            },
            scopeRequest: scopeRequest
        )
    }
    
    func upload(complition: ((Result<Bool, Error>) -> Void)?) {
        let group = DispatchGroup()
        var hasErrorOccured = false
        for fileName in fileNames {
            let fileURL = applicationSupportDirectoryURL.appendingPathComponent(fileName)
            group.enter()
            client?.files.upload(
                path: fileName,
                mode: .overwrite,
                autorename: true,
                mute: true,
                strictConflict: false,
                input: fileURL
            ).response { _, error in
                    if let error = error {
                        print(error)
                        hasErrorOccured = true
                    }
                group.leave()
                }
        }
        group.notify(queue: .main) {
            if hasErrorOccured {
                complition?(.failure(DropboxError.failureUpload))
            } else {
                complition?(.success(true))
            }
        }
    }
    
    func download(complition: ((Result<Bool, Error>) -> Void)?) {
        let group = DispatchGroup()
        var hasErrorOccured = false
        for fileName in fileNames {
            let destURL = applicationSupportDirectoryURL.appendingPathComponent(fileName)
            let destination: (URL, HTTPURLResponse) -> URL = { _, _ in
                return destURL
            }
            group.enter()
            client?.files.download(path: fileName, overwrite: true, destination: destination)
                .response { _, error in
                    if let error = error {
                        print(error)
                        hasErrorOccured = true
                    }
                    group.leave()
                }
        }
        group.notify(queue: .main) {
            if hasErrorOccured {
                complition?(.failure(DropboxError.failureDownload))
            } else {
                complition?(.success(true))
            }
        }
    }
}
