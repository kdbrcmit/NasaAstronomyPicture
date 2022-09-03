//
//  UITableViewCellIdentifiers.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import UIKit

/// Enum to define the cell idetifiers
enum NAPTableViewCellIdentifiers: String {
    case favourite = "FavouriteTableViewCell"
}

extension NAPTableViewCellIdentifiers {
    func registerTableViewCell(tableView : UITableView) {
        tableView.register(UINib(nibName: self.rawValue, bundle: nil), forCellReuseIdentifier: self.rawValue)
    }
    
    func getDequeueReusableCell(tableView : UITableView, indexpath : IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: self.rawValue, for: indexpath)
    }
}
