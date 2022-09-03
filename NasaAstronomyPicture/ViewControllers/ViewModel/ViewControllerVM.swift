//
//  ViewControllerVM.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation

class ViewControllerVM {
    var selectedDate: Date?
    var response: NAPFetchImageResponse?
    var httpClient: HTTPClient?
    
    /// Function to get the image data based on the date
    func fetchAstronomyImage(_ requestDate: Date,
                             completion:  @escaping (Result<Bool, NAPAPIError>) -> Void ) {
        selectedDate = requestDate
        let date = getStringValueForSelectedDate(requestDate)
        
        if let record = NAPCoreDataManager.shared.fetchRecordIfExists(date) {
            self.response = record
            completion(.success(true))
        } else {
            httpClient?.cancel()
            let endpoint = NAPEndpoint.fetchImage
            httpClient = HTTPClient(session: URLSession(configuration: .default))
            let params = [NetworkConstants.ParamNames.date: date]
            httpClient?.perform(from: endpoint,
                               params: params,
                               responseType: NAPFetchImageResponse.self) { result in
                switch result {
                case .failure(let error):
                    if error.localizedDescription != "cancelled" {
                        Logger.e(error.localizedDescription)
                        completion(.failure(error))
                    }
                case .success(let response):
                    self.response = response
                    NAPCoreDataManager.shared.insertImageData(response)
                    completion(.success(true))
                }
            }
        }
    }
    
    /// Function to check if current item is bookmerked or not
    func isBookmarked() -> Bool {
        return NAPCoreDataManager.shared.fetchRecordIfExists(response?.date ?? "")?.isBookmarked ?? false
    }
    
    /// Function to change the bookmark status in DB
    func changeBookmarkStatus(_ isBookmarked: Bool) {        
        NAPCoreDataManager.shared.changeBookmarkStatus(isBookmarked, date: response?.date ?? "")
    }
    
    /// Function to check if selected date is valid or not
    /// Date should not be the future date
    func isValidDate(_ requestDate: Date) -> Bool {
        if requestDate > Date() {
            Logger.e("future_date_selected".localized)
            return false
        }
        return true
    }
    
    /// Function to change the date to string format
    func getStringValueForSelectedDate(_ date: Date) -> String {
        let requestDateFormatter = DateFormatter()
        requestDateFormatter.dateFormat = "yyyy-MM-dd"
        return requestDateFormatter.string(from: date)
    }
}
