//
//  FavouriteViewController.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import UIKit

class FavouriteViewController: UIViewController, BaseProtocol {
    var viewModel: FavouriteViewControllerVM!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "favourite".localized
        setupNavigationBar()
        prepareTableView()
        self.view.backgroundColor = NAPThemeManager.current.backgroundColor
    }
    
    /// Function to setup the navigation bar
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem?.title = "back".localized
        self.navigationItem.leftBarButtonItem?.applyStyle()
    }
    
    /// Function to setup the table view properties
    func prepareTableView() {
        NAPTableViewCellIdentifiers.favourite.registerTableViewCell(tableView: self.tableView)
        self.tableView.backgroundColor = .clear
    }
    
    /// Function to configure the viewmodel
    func configure(_ viewModel: FavouriteViewControllerVM) {
        self.viewModel = viewModel
        self.viewModel.fetchAllFavouriteRecords()
    }
}

extension FavouriteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableViewCell = NAPTableViewCellIdentifiers.favourite.getDequeueReusableCell(tableView: tableView,
                                                                                            indexpath: indexPath) as? FavouriteTableViewCell  {
            tableViewCell.configure(viewModel.records[indexPath.row])
            return tableViewCell
        } else {
            return UITableViewCell()
        }
    }
}
