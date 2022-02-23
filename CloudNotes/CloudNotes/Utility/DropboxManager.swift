//
//  DropboxManager.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/21.
//

import Foundation
import SwiftyDropbox

struct DropboxManager {
    func connectDropbox(viewController: UIViewController) {
        let scopes = ["account_info.read", "files.content.write", "files.content.read"]
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: scopes, includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    func upload(memos: [Memo]) {
        memos.forEach { memo in
            guard let title = memo.title,
                  let body = memo.body,
                  let id = memo.id else {
                return
            }
            
            let memoData = title + String.lineBreak + body
            guard let uploadData = memoData.data(using: .utf8) else {
                return
            }
            
            DropboxClientsManager.authorizedClient?.files.upload(path: "/\(id)\(FileFormat.txt)", mode: .overwrite, input: uploadData)
        }
    }
    
    func delete(memo: Memo) {
        guard let id = memo.id else {
            return
        }
        
        DropboxClientsManager.authorizedClient?.files.deleteV2(path: "/\(id)\(FileFormat.txt)", parentRev: nil)
    }
    
    func fetchFilePaths(completion: @escaping ([Files.Metadata]) -> Void) {
        DropboxClientsManager.authorizedClient?.files.listFolder(path: .blank)
            .response { response, _ in
                if let response = response {
                    completion(response.entries)
                }
            }
    }
    
    func download(from path: String, completion: @escaping (DropboxFile) -> Void) {
        DropboxClientsManager.authorizedClient?.files.download(path: path)
            .response { data, _ in
                guard let data = data else {
                    return
                }
                
                let metaData = data.0
                let content = data.1
                
                guard let contentString = String(data: content, encoding: .utf8) else {
                    return
                }
                
                let (title, body) = contentString.splitedText
                
                let dropboxFile = DropboxFile(id: metaData.name, title: title, body: body, clientModified: metaData.clientModified)
                completion(dropboxFile)
            }
    }
}
