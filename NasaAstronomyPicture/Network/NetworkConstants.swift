//
//  NetworkConstants.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation

struct NetworkConstants {
    struct Urls {
        static let developmentBaseUrl = "https://api.nasa.gov"
    }
    
    struct Paths {
        static let fetchImage = "/planetary/apod"
    }
    
    struct ParamNames {
        static let api_key = "api_key"
        static let date = "date"
    }
    
    struct Keys {
        static let apiKey = "Q43WCsMxZ9Eb05BXRgcvzmrIXrXgANqKOSjhWYWp"
    }
}
