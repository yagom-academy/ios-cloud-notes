import Foundation
import SwiftyDropbox

class DropboxProvider: Synchronizable {
    let client = DropboxClientsManager.authorizedClient
    let coredataURL: URL? = try? FileManager.default.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
    )
    let filePaths = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-shm", "/CloudNotes.sqlite-wal"]
    var lastUpdatedDate: Date?

    func upload(_ completionHandler: @escaping (DropboxError?) -> Void) {
        let group = DispatchGroup()
        var errors: [CallError<Files.UploadError>?] = []
        filePaths.forEach { filePath in
            group.enter()
            guard let fileURL = coredataURL?.appendingPathComponent(filePath) else {
                return
            }

            client?.files.upload(
                path: "/CloudNote\(filePath)",
                mode: .overwrite,
                autorename: false,
                clientModified: nil,
                mute: false,
                propertyGroups: nil,
                strictConflict: false,
                input: fileURL
            )
                .response { _, error in
                    if error != nil {
                        errors.append(error)
                        completionHandler(.uploadFailure)
                    }
                    group.leave()
                }
        }
        group.notify(queue: .main) {
            if errors.isEmpty {
                completionHandler(nil)
                self.lastUpdatedDate = Date()
            } else {
            completionHandler(.downloadFailure)
            }
        }
    }

    func download(_ completionHandler: @escaping (DropboxError?) -> Void) {
        let group = DispatchGroup()
        var errors: [CallError<Files.DownloadError>?] = []
        filePaths.forEach { filePath in
            group.enter()
            guard let fileURL = coredataURL?.appendingPathComponent(filePath) else {
                return
            }
            client?.files.download(path: "/CloudNote\(filePath)")
                .response { response, error in
                    if let response = response {
                        let fileContents = response.1
                        FileManager.default.createFile(
                            atPath: fileURL.path,
                            contents: fileContents,
                            attributes: nil)
                    } else if error != nil {
                        errors.append(error)
                    }
                    group.leave()
                }
        }

        group.notify(queue: .main) {
            if errors.isEmpty {
                completionHandler(nil)
            } else {
            completionHandler(.downloadFailure)
            }
        }
    }

    func logIn(at controller: UIViewController) {
        let scopeRequest = ScopeRequest(
            scopeType: .user,
            scopes: ["account_info.read", "files.content.write", "files.content.read"],
            includeGrantedScopes: false
        )
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: controller,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in
                UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
}
