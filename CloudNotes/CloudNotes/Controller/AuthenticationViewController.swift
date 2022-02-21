//
//  AuthenticationViewController.swift
//  CloudNotes
//
//  Created by 박병호 on 2022/02/21.
//

import UIKit

class AuthenticationViewController: UIViewController {

    let dropBoxManager = DropboxManager()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.frame = self.view.frame
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        view.addSubview(activityIndicator)
        DispatchQueue.main.async {
            self.dropBoxManager.authorize(self)
        }
    }

}
