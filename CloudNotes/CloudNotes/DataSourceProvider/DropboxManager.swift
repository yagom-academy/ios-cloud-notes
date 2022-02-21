import Foundation
import SwiftyDropbox

struct DropboxManager {
    let client = DropboxClientsManager.authorizedClient
    let coredataURL: URL? = try? FileManager.default.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
    )
    let filePaths = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-shm", "/CloudNotes.sqlite-wal"]

    func upload(_ completionHandelr: @escaping (DropboxError?) -> Void) {
        filePaths.forEach { filePath in
            guard let fileURL = coredataURL?.appendingPathComponent(filePath) else {
                return
            }

            client?.files.upload(path: "/CloudNote\(filePath)", mode: .overwrite, autorename: false, clientModified: nil, mute: false, propertyGroups: nil, strictConflict: false, input: fileURL)
                .response { _ , error in
                    if error != nil {
                        completionHandelr(.uploadFailure)
                    }
                }
        }
    }

    func download(_ completionHandelr: @escaping (DropboxError?) -> Void) {
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
                        completionHandelr(.downloadFailure)
                    }
                }
        }
    }
}
