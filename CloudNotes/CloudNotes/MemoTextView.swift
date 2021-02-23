//
//  MemoTextView.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/23.
//

import UIKit

class MemoTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let glyphIndex: Int? = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: nil)
        let index: Int? = layoutManager.characterIndexForGlyph(at: glyphIndex ?? 0)
        if let characterIndex = index, characterIndex < textStorage.length {
            if textStorage.attribute(NSAttributedString.Key.link, at: characterIndex, effectiveRange: nil) != nil {
                return self
            }
            else {
                    self.isEditable = true
                    self.becomeFirstResponder()
                    return self
            }
        }
        
        return nil
    }
}
