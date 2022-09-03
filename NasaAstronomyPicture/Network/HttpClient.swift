//
//  HttpClient.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation

/// Custom error to denote the api error with localization
public enum NAPAPIError: Error {
    case error(message: String)
    
    public var localizedDescription: String {
        switch self {
        case .error(let message): return message
        }
    }
}

/// Protocol to define the URLSession implementation
internal protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

internal protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

// MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: HttpClient Implementation
/// Class to handle the generic api and return the callback after completion
internal class HTTPClient: NAPAPIClient {
    let session: URLSessionProtocol
    var dataProtocol: URLSessionDataTaskProtocol?
    
    /// Function to initialize the HTTPClient
    /// - Parameter session: URLSessionProtocol object
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    /// Function to perform generic api calls
    /// - Parameters:
    ///   - endpoint: Object of Endpoint call
    ///   - params: Parameters
    ///   - responseType: Generic response type
    ///   - completion: Completion block to send success/error
    func perform<T>(from endpoint: NAPEndpoint,
                    params: [String: String],
                    responseType: T.Type,
                    completion: @escaping (Result<T, NAPAPIError>) -> Void) where T: Decodable {
        dataProtocol = fetch(from: endpoint, params: params, decode: { json -> T? in
            return json as? T
        }, completion: completion)
    }
    
    func cancel() {
        self.dataProtocol?.cancel()
    }
}
