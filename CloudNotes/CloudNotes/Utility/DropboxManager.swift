//
//  DropboxManager.swift
//  CloudNotes
//
//  Created by Yeon on 2021/03/05.
//

import UIKit
import SwiftyDropbox

protocol DropboxDownloadDelegate: class {
    func listViewUpdate()
}

final class DropboxManager {
    static let shared = DropboxManager()
    private init() {}
    weak var delegate: DropboxDownloadDelegate?
    var client = DropboxClientsManager.authorizedClient
    let coreDataFilePath: URL? = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
    let coreDataFiles = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-wal", "/CloudNotes.sqlite-shm"]
    
    func getAuthorize(_ viewController: UIViewController) {
        guard DropboxClientsManager.authorizedClient == nil else {
            return
        }
        let scopeRequest = ScopeRequest(scopeType: .user,
                                        scopes: ["files.metadata.write", "files.metadata.read", "files.content.write", "files.content.read"],
                                        includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { (url) in
                UIApplication.shared.open(url, options: [:])
            },
            scopeRequest: scopeRequest
        )
    }
    
    func upload() {
        for coreDataFileName in coreDataFiles {
            guard let coreDataFilePath = coreDataFilePath else {
                return
            }
            let data = coreDataFilePath.appendingPathComponent(coreDataFileName)
            if let client = client {
                client.files.upload(path: coreDataFileName, mode: .overwrite, input: data).response { (metaData, error) in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func download() {
        for cloudDataFileName in coreDataFiles {
            guard let coreDataFilePath = coreDataFilePath else {
                return
            }
            let cloudDataFileURL = coreDataFilePath.appendingPathComponent(cloudDataFileName)
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return cloudDataFileURL
            }
            client?.files.download(path: cloudDataFileName, overwrite: true, destination: destination).response(completionHandler: { (response, error) in
                if let error = error {
                    print(error)
                }
                
                self.delegate?.listViewUpdate()
            })
        }
    }
}
