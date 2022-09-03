//
//  BaseProtocol.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation

/// Protocol to enforce the MVVM in the project
protocol BaseProtocol {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
    func configure(_ viewModel: ViewModel)
}
