//
//  UIColor+Extensions.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import UIKit

extension UIColor {
    /// Function to use the hex color code
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString)
        if hexaString.hasPrefix("#") {
            _ = chars.dropFirst()
        }
        self.init(red:   .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  blue:  .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  alpha: alpha)}
}
