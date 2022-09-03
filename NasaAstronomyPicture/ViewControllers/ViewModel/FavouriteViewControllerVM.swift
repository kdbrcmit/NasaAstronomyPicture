//
//  FavouriteViewControllerVM.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import Foundation

class FavouriteViewControllerVM {
    var viewModel: ViewControllerVM!
    var records: [ImageOfTheDay] = []
    
    /// Function to fetch all the favourite records
    func fetchAllFavouriteRecords() {
        records = NAPCoreDataManager.shared.fetchAllBookmarkedRecords() ?? []
    }    
}
