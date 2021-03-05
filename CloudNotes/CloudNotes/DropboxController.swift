import UIKit
import SwiftyDropbox

struct DropboxController {
    private let client = DropboxClientsManager.authorizedClient
    weak var delegate: DownloadCompleteDelegate?
    let backupFilePath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    
    let backupFiles = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-wal", "/CloudNotes.sqlite-shm"]
    
    func authorize(_ viewController: UIViewController) {
        guard DropboxClientsManager.authorizedClient == nil else {
            print("ee")
            return
        }
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "account_info.write", "files.metadata.write", "files.metadata.read", "files.content.write", "files.content.read"], includeGrantedScopes: false)

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
    
    func uploadBackupMemoData() {
        for uploadFileName in backupFiles {
            let backupFile = backupFilePath.appendingPathComponent(uploadFileName)
            if let client = client {
                client.files.upload(path: uploadFileName, mode: .overwrite, input: backupFile).response { metaData, error in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func DownloadBackupMemoData() {
        for downloadFileName in backupFiles {
            let backupFileURL = backupFilePath.appendingPathComponent(downloadFileName)
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return backupFileURL
            }
            client?.files.download(path: downloadFileName, overwrite: true, destination: destination).response(completionHandler: { response, error in
                if let error = error {
                    print(error)
                }
                self.delegate?.tableViewUpdate()
            })
        }
    }
}

protocol DownloadCompleteDelegate: class {
    func tableViewUpdate()
}
