//
//  DropboxManager.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/21.
//

import Foundation
import SwiftyDropbox

struct DropboxManager {
    private var client = DropboxClientsManager.authorizedClient
    
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
}
