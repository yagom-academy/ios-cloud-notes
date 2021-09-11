//
//  ComposeTextViewControllerDelegate.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/11.
//

import Foundation

protocol ComposeTextViewControllerDelegate: AnyObject {
    func didTapSaveButton(_ text: String)
}
