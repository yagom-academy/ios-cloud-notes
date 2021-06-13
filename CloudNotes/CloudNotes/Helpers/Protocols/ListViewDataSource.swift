//
//  ListViewDataSource.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/13.
//

import UIKit

protocol ListViewDataSource: AnyObject {
    var listCollectionView: UICollectionView? { get }
}
