import Foundation
import SwiftyDropbox

class DropboxProvider: Synchronizable {
    var lastUpdatedDate: Date?
    private let client = DropboxClientsManager.authorizedClient
    private let fileURL: URL? = try? FileManager.default.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
    )
    private let filePath = "/CloudNotes.txt"

    func upload(
        memoString: String,
        _ completionHandler: @escaping (SynchronizationError?) -> Void
    ) {
        guard let filePath = self.fileURL?.appendingPathComponent(filePath)
        else {
            return
        }

        try? memoString.write(to: filePath, atomically: false, encoding: .utf8)

        self.client?.files.upload(
            path: "/CloudNote/CloudNote.txt",
            mode: .overwrite,
            autorename: false,
            clientModified: nil,
            mute: false,
            propertyGroups: nil,
            strictConflict: false,
            input: filePath
        )
            .response { _, error in
                if error != nil {
                    completionHandler(.uploadFailure)
                }
                self.lastUpdatedDate = Date()
            }
    }

    func download(_ completionHandler: @escaping (Result<[Content], SynchronizationError>) -> Void) {
        guard let filePath = fileURL?.appendingPathComponent(filePath) else {
            return
        }

        self.client?.files.download(path: "/CloudNote/CloudNote.txt")
            .response { response, error in
                if let response = response {
                    let fileContents = response.1
                    FileManager.default.createFile(
                        atPath: filePath.path,
                        contents: fileContents,
                        attributes: nil)
                } else if error != nil {
                    completionHandler(.failure(.downloadFailure))
                }

                let memosFile = FileManager.default.contents(atPath: filePath.path)

                guard let convertedMemos = self.convertTextToModel(
                    from: String(data: memosFile!, encoding: .utf8)!
                ) else {
                    return
                }

                completionHandler(.success(convertedMemos))
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

    func convertModelToText(from model: [Content]) -> String {
        let firstBoundary = UUID().uuidString
        var string = ""

        model.forEach { content in
            let secondBoundary = "--\(content.identification.uuidString)--"

            string += "--\(firstBoundary)--"
            string += "\n"
            string += secondBoundary
            string += "\n"
            string += content.identification.uuidString
            string += secondBoundary
            string += String(content.lastModifiedDate)
            string += secondBoundary
            string += content.title
            string += secondBoundary
            string += content.body
        }

        return string
    }

    func convertTextToModel(from text: String) -> [Content]? {
        let separatedText = text.split(
            separator: "\n",
            maxSplits: 1,
            omittingEmptySubsequences: true
        )
        var content = [Content]()

        guard let memoSeparator = separatedText.first,
              let memosText = separatedText.last
        else {
            return nil
        }

        let memos = memosText.components(separatedBy: String(memoSeparator))
        memos.forEach { memo in
            let separatedMemoText = memo.split(
                separator: "\n",
                maxSplits: 1,
                omittingEmptySubsequences: true
            )

            guard let memoComponentsSeparator = separatedMemoText.first,
                  let memoText = separatedMemoText.last
            else {
                return
            }

            let memoComponents = memoText.components(separatedBy: memoComponentsSeparator)

            guard let date = Double(memoComponents[1]),
                  let uuid = UUID(uuidString: memoComponents[0]),
                  memoComponents.count == 4
            else {
                return
            }

            content.append(
                Content(
                    title: memoComponents[2],
                    body: memoComponents[3],
                    lastModifiedDate: date,
                    identification: uuid
                )
            )
        }

        return content
    }
}
