import Foundation
import SwiftyDropbox

class DropBoxManager: DataProvider {
    let client = DropboxClientsManager.authorizedClient
    
    func create(attributes: [String : Any]) {
        //
    }
    
    func read(index: IndexPath) -> MemoType? {
        downloadToDocuments()
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dropboxURL = directoryURL.appendingPathComponent("dropboxMemos").description
        let filePaths = fileManager.subpaths(atPath: dropboxURL)
        var sampleMemos: [SampleData]?
        
        do {
            let memos = try filePaths?.map({ (path) -> SampleData in
                let data = fileManager.contents(atPath: path)
                return try JSONDecoder().decode(SampleData.self, from: data ?? Data())
            })
            sampleMemos = memos?.sorted(by: {
                guard let memo1 = $0.lastModified, let memo2 = $1.lastModified else {
                    return false
                }
                return memo1 > memo2 }
            )
        } catch {
            print("dropbox download fail")
        }
        return sampleMemos?[index.row]
    }
    
    func update(target: MemoType, attributes: [String : Any]) {
        upload(target: target, attributes: attributes)
    }
    
    func delete(target: MemoType) {
        //
    }
    
    func countAllData() -> Int {
        1
    }
    
    func upload(target: MemoType, attributes: [String: Any]) {
        let memo = SampleData(title: target.title, body: target.body, lastModified: target.lastModified, identifier: target.identifier)
        guard let data = try? JSONEncoder().encode(memo) else {
            return
        }
        
        client?.files.upload(path: "/\(String(describing: target.identifier))/memos", input: data).response{ response, error in
            if let response = response {
                print(response)
            } else if let error = error {
                print(error)
            }
        }.progress({ progressData in
            print(progressData)
        })
    }
    
    private func downloadToDocuments() {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destURL = directoryURL.appendingPathComponent("dropboxMemos")
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destURL
        }
        client?.files.download(path: "/memos", overwrite: true, destination: destination)
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
