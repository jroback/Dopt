//
//  UILabelLineHeightHelper.swift
//  Resque
//
//  Created by Roback, Jerry on 2/2/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import Foundation

extension UILabel {

    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
}
