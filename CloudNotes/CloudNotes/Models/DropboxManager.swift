//
//  DropboxManager.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/14.
//

import Foundation
import SwiftyDropbox

struct DropboxManager {
    static let shared = DropboxManager()
    let client = DropboxClientsManager.authorizedClient
    var areThereAuthorizedClient: Bool {
        guard let _ = DropboxClientsManager.authorizedClient else {
            return true
        }
        return false
    }
    
    func authorize(viewController: UIViewController) {
        guard areThereAuthorizedClient else {
            return
        }
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: viewController,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url)
                                                      })
    }
    
    func uploadData(files: [String], directoryURL: URL) {
        for file in files {
            let fileData = directoryURL.appendingPathComponent(file)
            self.client?.files.upload(path: file, mode: .overwrite ,input: fileData)
                .response { response, error in
                    if let response = response {
                        print("response: ", response)
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print("progressData: ",progressData)
                }
        }
    }
    
    func downLoadData(files: [String], directoryURL: URL) {
        for file in files {
            let destURL = directoryURL.appendingPathComponent(file)
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return destURL
            }
            self.client?.files.download(path: file, overwrite: true, destination: destination)
                .response { response, error in
                    if let response = response {
                        print("response: ", response)
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print("progressData: ", progressData)
                }
        }
    }
    
}
