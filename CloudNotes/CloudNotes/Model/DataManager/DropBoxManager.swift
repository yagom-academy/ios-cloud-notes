import Foundation
import SwiftyDropbox

class DropBoxManager {
    let client = DropboxClientsManager.authorizedClient
    
    func upload () {
        guard let fileData = "CloudNotes_July".data(
            using: String.Encoding.utf8,
            allowLossyConversion: false
        ) else {
            return
        }
        
        let request = client?.files.upload(path: "/test/path/in/Dropbox/account", input: fileData)
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
    
    func downloadToCoreData() {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destURL = directoryURL.appendingPathComponent("myTestFile")
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destURL
        }
        client?.files.download(path: "/test/path/in/Dropbox/account", overwrite: true, destination: destination)
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
}
