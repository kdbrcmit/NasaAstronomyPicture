//
//  Endpoints.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation

/// Protocol to handle the api information like base url, path and method
internal protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var method: NAPApiMethod { get }
}

/// Enum to define the api method
internal enum NAPApiMethod: String {
    case put = "PUT"
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

/// Enum to define the api endpoints
internal enum NAPEndpoint {
    case fetchImage
}

extension NAPEndpoint: Endpoint {
    var base: String {
        switch NAPEnvironment.shared.environment {
        case .development:
            return NetworkConstants.Urls.developmentBaseUrl
        }
    }
    
    var path: String {
        switch self {
        case .fetchImage:
            return NetworkConstants.Paths.fetchImage
        }
    }
    
    var method: NAPApiMethod {
        switch self {
        case .fetchImage:
            return NAPApiMethod.get
        }
    }
    
    /// Function to get the urlRequest based on api methods
    func prepareUrlRequest(queryParams: [String: String]) -> URLRequest? {
        switch self.method {
        case .get:
            return prepareGetUrlRequest(queryParams: queryParams)
        default:
            /// Can create separate method based on the api method
            return prepareRequest(queryParams: queryParams)
        }
    }
    
    /// Function to prepare request for GET api method call
    private func prepareGetUrlRequest(queryParams: [String : String]) -> URLRequest? {
        guard var component = URLComponents(string: base + path) else {
            assertionFailure("wrong_url".localized)
            return nil
        }
        component.queryItems = [URLQueryItem(name: NetworkConstants.ParamNames.api_key,
                                             value: NetworkConstants.Keys.apiKey)]
        
        for key in queryParams.keys {
            component.queryItems!.append(URLQueryItem(name: key,
                                                      value: queryParams[key]))
        }
        guard let url = component.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        return request
    }
    
    /// Common function to prepare the api requests
    private func prepareRequest(queryParams: [String : String]) -> URLRequest? {
        guard let url = URL(string: base + path) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpBody = try? JSONEncoder().encode(queryParams)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        return request
    }
}
