//
//  CoreDataCloudMemoDelegate.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit

protocol CoreDataCloudMemoDelegate: AnyObject {
    func didSnapshotFinished(_ snapshot: NSDiffableDataSourceSnapshot<String, CloudMemo>)
}
