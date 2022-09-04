//
//  NAPFetchImageResponse.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation

enum NAPMediaType: String, Codable {
    case video
    case image
}

/// Function to handle the api response
struct NAPFetchImageResponse: Codable {
    var isBookmarked = false
    let id: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let mediaType: NAPMediaType?
    let serviceVersion: String?
    let title: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title
        case url
    }
}
