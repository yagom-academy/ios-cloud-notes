import SwiftyDropbox
import UIKit

struct DropboxManager {
    private let client = DropboxClientsManager.authorizedClient
    private let applicationSupportDirectoryURL = FileManager.default.urls(
        for: .applicationSupportDirectory,
        in: .userDomainMask
    )[0]
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
    
    func upload() {
        for fileName in fileNames {
            let fileURL = applicationSupportDirectoryURL.appendingPathComponent(fileName)
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
                    }
                }
        }
    }
    
    func download(complition: ((CallError<Files.DownloadError>?) -> Void)?) {
        let group = DispatchGroup()
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
                        complition?(error)
                    }
                    group.leave()
                }
        }
        group.notify(queue: .main) {
            complition?(nil)
        }
    }
}
