import Foundation
import SwiftyDropbox

class DropboxManager {
    let client = DropboxClientsManager.authorizedClient
    let coredataURL: URL? = try? FileManager.default.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
    )
    let filePaths = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-shm", "/CloudNotes.sqlite-wal"]

    func upload(_ completionHandler: @escaping (DropboxError?) -> Void) {
        filePaths.forEach { filePath in
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
                .response { response, error in
                    print(response)
                    if error != nil {
                        print(error)
                        completionHandler(.uploadFailure)
                    }
                }
        }
    }

    func download(_ completionHandler: @escaping (DropboxError?) -> Void) {
        filePaths.forEach { filePath in
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
                        print(error)
                        completionHandler(.downloadFailure)
                    }
                }
        }
    }
}
