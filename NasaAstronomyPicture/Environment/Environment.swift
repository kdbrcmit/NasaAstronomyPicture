//
//  Environment.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation

/// Enum to define the app environments
enum Environment: String {
    case development = "development"
}

/// Class to handle the app environment for extensibility
public class NAPEnvironment: NSObject {
    static let shared = NAPEnvironment()
    private override init() { }
    
    // Setting the default environment as developement
    var environment: Environment = .development
    
    func setEnvironment(_ environment: Environment) {
        self.environment = environment
    }
}
