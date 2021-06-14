//
//  Alter.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/13.
//

import UIKit

extension UIViewController {
    func alterError(_ error: String?) {
        let message = error
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        alert.present(self, animated: true)
    }
}
