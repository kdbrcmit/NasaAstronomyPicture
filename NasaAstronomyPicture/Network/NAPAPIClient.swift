//
//  NAPAPIClient.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation


internal enum NAPErrorMessages: String {
    case invalidResponse = "invalid_response"
    case decodingError = "decoding_error"
    case unknownError = "unknown_error"
    case invalidData = "invalid_data"
    case serverError = "server_error"
}

/// Protocol to define the generic function to perform the api call
internal protocol NAPAPIClient {
    var session: URLSessionProtocol { get }
    func fetch<T: Decodable>(from endpoint: NAPEndpoint,
                             params: [String: String],
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T, NAPAPIError>) -> Void) -> URLSessionDataTaskProtocol?
}

internal extension NAPAPIClient {
    /// Function to make the generic api call
    /// - Parameters:
    ///   - endpoint: Object of Endpoint call
    ///   - params: Parameters
    ///   - decode: Decode function to decode the api response to model class
    ///   - completion: Completion block to return the success/failure response
    func fetch<T: Decodable>(from endpoint: NAPEndpoint,
                             params: [String: String],
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T, NAPAPIError>) -> Void) -> URLSessionDataTaskProtocol? {
        guard let request: URLRequest = endpoint.prepareUrlRequest(queryParams: params) else {
            Logger.e("wrong_endpoint".localized)
            completion(.failure(.error(message: "wrong_endpoint".localized)))
            return nil
        }
        let task = session.dataTask(with: request) { data, response, error in
            self.decodingTask(with: response, data: data, error: error, decodingType: T.self) { (json , error) in
                Logger.d("JSON Parsing Success: \(String(describing: json)))")
                self.handleJson(json: json, error: error, decode: decode, completion: completion)
            }
        }
        task.resume()
        return task
    }
    
    /// Function to handle the json api response. It decodes the json to model class and return the result
    /// - Parameters:
    ///   - json: Json response of api
    ///   - error: Api error if occured
    ///   - decode: Decode function to decode the api response to model class
    ///   - completion: Completion block to return the success/failure response
    func handleJson<T: Decodable>(json: T?,
                                  error: NAPAPIError?,
                                  decode: @escaping (Decodable) -> T?,
                                  completion: @escaping (Result<T, NAPAPIError>) -> Void) {
        //MARK: change to main queue
        DispatchQueue.main.async {
            guard let json = json else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(.error(message: NAPErrorMessages.invalidResponse.rawValue.localized)))
                }
                return
            }
            if let value = decode(json) {
                completion(.success(value))
            } else {
                completion(.failure(.error(message: NAPErrorMessages.decodingError.rawValue.localized)))
            }
        }
    }
    
    /// Function to handle the response and decode the data
    /// - Parameters:
    ///   - response: URLResponse of the api
    ///   - data: Data returned from the api
    ///   - error: Api error if occured
    ///   - decodingType: Type of response model to you want to decode into
    ///   - completion: Completion block to return the success/failure response
    func decodingTask<T: Decodable>(with response: URLResponse?,
                                    data: Data?,
                                    error: Error?,
                                    decodingType: T.Type,
                                    completion: @escaping (T?, NAPAPIError?) -> Void) {
        guard let error = error else {
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.e(NAPErrorMessages.unknownError.rawValue.localized)
                completion(nil, .error(message: NAPErrorMessages.unknownError.rawValue.localized))
                return
            }
            handleDecodingTask(data: data, httpResponse: httpResponse,
                               decodingType: decodingType, completion: completion)
            return
        }
        Logger.e("\(String(describing: error.localizedDescription))")
        completion(nil, .error(message: "\(String(describing: error.localizedDescription))"))
    }
    
    /// Function to handle the decoding of the api response
    /// - Parameters:
    ///   - data: Data returned from the api
    ///   - httpResponse: URLResponse of the api
    ///   - decodingType: Type of response model to you want to decode into
    ///   - completion: Completion block to return the success/failure response
    func handleDecodingTask<T: Decodable>(data: Data?,
                                          httpResponse: HTTPURLResponse,
                                          decodingType: T.Type,
                                          completion: @escaping (T?, NAPAPIError?) -> Void) {
        if let data = data, httpResponse.statusCode == 200 {
            do {
                let genericModel = try JSONDecoder().decode(decodingType, from: data)
                completion(genericModel, nil)
            } catch {
                Logger.e(NAPErrorMessages.decodingError.rawValue.localized + ": \(String(describing: error))")
                completion(nil, .error(message: NAPErrorMessages.decodingError.rawValue.localized
                                       + ":" + " \(String(describing: error.localizedDescription))"))
            }
        } else {
            Logger.e(NAPErrorMessages.invalidData.rawValue.localized
                     + ": \(String(describing: httpResponse))")
            completion(nil, .error(message: NAPErrorMessages.invalidData.rawValue.localized + ":" +
                                   " \(String(describing: httpResponse))"))
        }
    }
}
