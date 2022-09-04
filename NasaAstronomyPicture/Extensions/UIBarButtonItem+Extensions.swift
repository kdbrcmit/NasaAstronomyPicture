//
//  UIBarButtonItem+Extensions.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import UIKit

extension UIBarButtonItem {
    /// Function to apply the style on Bar button
    func applyStyle() {
        let attributes = [NSAttributedString.Key.font :
                            UIFont.boldSystemFont(ofSize: 18),
                          NSAttributedString.Key.foregroundColor:
                            NAPThemeManager.current.color_0080ff ]
        self.setTitleTextAttributes(attributes, for: .normal)
    }
}
