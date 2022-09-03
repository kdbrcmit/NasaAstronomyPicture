//
//  FavouriteTableViewCell.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var desriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = NAPThemeManager.current.textColor
        dateLabel.textColor = NAPThemeManager.current.textColor
        desriptionLabel.textColor = NAPThemeManager.current.textColor
        backgroundColor = .clear
        separatorLabel.backgroundColor = NAPThemeManager.current.textColor
    }
    
    /// Function to configure the cell data
    func configure(_ model: ImageOfTheDay) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        desriptionLabel.text = model.explanation
        selectionStyle = .none
    }
    
}
