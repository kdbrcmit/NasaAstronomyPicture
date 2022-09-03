//
//  String+Extensions.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import UIKit

extension String {
    /// Variable to convert the string to localize string
    var localized: String {
        return NSLocalizedString(self, comment: "\(self) - localized key not found")
    }
}
