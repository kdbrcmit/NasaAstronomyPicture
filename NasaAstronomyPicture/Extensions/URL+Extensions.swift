//
//  URL+Extensions.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import Foundation

extension URL {
    /// Variable to build the document directory path
    var documentURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(self.lastPathComponent)
    }
}
