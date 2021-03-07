import Foundation
import SwiftyDropbox
import UIKit

protocol DropboxDownloadDelegate: class {
    func fetchTableViewList()
}

struct DropboxManager {
    static weak var delegate: DropboxDownloadDelegate?
    private static var client = DropboxClientsManager.authorizedClient
    static let requiredScope = ["account_info.read", "account_info.write", "files.metadata.write", "files.metadata.read", "files.content.write", "files.content.read"]
    static let fileNames = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-wal", "/CloudNotes.sqlite-shm"]
    static let backUpPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    
    static func authorizeDropbox(viewController: UIViewController) {
        guard DropboxClientsManager.authorizedClient == nil else {
             return
        }

        let scopeRequest = ScopeRequest(scopeType: .user, scopes: requiredScope, includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { url in UIApplication.shared.open(url, options: [:]) },
            scopeRequest: scopeRequest
        )
    }
    
    static func upload() {
        for file in fileNames {
            let documentsDirectory = backUpPath.appendingPathComponent(file)
            client?.files.upload(path: file, mode: .overwrite, input: documentsDirectory).response { response, error in
                if let error = error {
                    print(error)
                }
                if let response = response {
                    print(response)
                }
            }
        }
    }
    
    static func download() {
        for file in fileNames {
            let destinationURL = backUpPath.appendingPathComponent(file)
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return destinationURL
            }
            client?.files.download(path: file, overwrite: true, destination: destination).response { response, error in
                if let error = error {
                    print(error)
                }
                if let response = response {
                    print(response)
                }
                
                delegate?.fetchTableViewList()
            }
        }
    }
}
