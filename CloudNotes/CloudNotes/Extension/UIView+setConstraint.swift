//
//  Extension+UIView.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/08.
//

import UIKit

extension UIView {
    func setConstraintEqualToAnchor(superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let margin = superView.layoutMarginsGuide
        let top = self.topAnchor.constraint(equalTo: margin.topAnchor)
        let leading = self.leadingAnchor.constraint(equalTo: margin.leadingAnchor)
        let trailng = self.trailingAnchor.constraint(equalTo: margin.trailingAnchor)
        let bottom = self.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        
        NSLayoutConstraint.activate([
            top, leading, trailng, bottom
        ])
    }
}
