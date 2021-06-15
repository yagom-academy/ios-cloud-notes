//
//  NoteManagerDelegate.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/09.
//

import UIKit

protocol NoteListViewControllerDelegate: AnyObject {
    var listCollectionView: UICollectionView? { get }
    func applyTextUpdate(with newText: String)
    func applySnapshot(animatingDifferences: Bool)
}
