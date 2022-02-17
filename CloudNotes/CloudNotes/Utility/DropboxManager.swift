import SwiftyDropbox
import UIKit

struct DropboxManager {
    private let client = DropboxClientsManager.authorizedClient
    private let applicationSupportDirectoryURl = FileManager.default.urls(
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
            includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            },
            scopeRequest: scopeRequest
        )
    }
    
    func upload() {
        for fileName in fileNames {
            let fileURL = applicationSupportDirectoryURl.appendingPathComponent(fileName)
            client?.files.upload(
                path: fileName,
                mode: .overwrite,
                autorename: true,
                mute: true,
                strictConflict: false,
                input: fileURL
            ).response { response, error in
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
    
    func download(_ tableViewController: NotesViewController?) {
        let group = DispatchGroup()
        for fileName in fileNames {
            let destURL = applicationSupportDirectoryURl.appendingPathComponent(fileName)
            let destination: (URL, HTTPURLResponse) -> URL = { _, _ in
                return destURL
            }
            group.enter()
            client?.files.download(path: fileName, overwrite: true, destination: destination)
                .response { response, error in
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
            PersistentManager.shared.setUpNotes()
            tableViewController?.tableView.reloadData()
            tableViewController?.stopActivityIndicator()
        }
    }
}
