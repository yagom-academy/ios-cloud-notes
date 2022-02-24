import Foundation
import SwiftyDropbox
import CoreData

struct DropBoxManager {
    private let dropBoxClient = DropboxClientsManager.authorizedClient
    
    func presentSafariViewController(controller: UIViewController) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: [
            "account_info.read",
            "files.metadata.read",
            "files.content.write",
            "files.content.read"]
                                        , includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: controller,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    func createFolderAtDropBox() {
        dropBoxClient?.files.createFolderV2(path: "/test/path/in/Dropbox/account").response { response, error in
            if let response = response {
                print(response)
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func uploadToDropBox() {
        let fileData = "testing data example".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        let request = dropBoxClient?.files.upload(path: "/test/path/in/Dropbox/account", mode: .overwrite, autorename: true, clientModified: Date(), mute: false, propertyGroups: nil, strictConflict: false, input: fileData)
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
    
    func downloadFromDropBox() {
        let fileURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CloudNotes.sqlite")
        
        let destination: (URL, HTTPURLResponse) -> URL = { _, response in
            return fileURL
        }
        
        dropBoxClient?.files.download(path: "/test/path/in/Dropbox/CloudNotes.sqlite", overwrite: true, destination: destination)
            .response(queue: .main) { response, error in
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
