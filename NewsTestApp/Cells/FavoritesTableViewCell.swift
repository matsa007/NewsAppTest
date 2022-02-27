//
//  FavoritesTableViewCell.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 26.02.2022.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    @IBOutlet weak var favoritesTitleLabel: UILabel!
    @IBOutlet weak var favoritesSubtitleLabel: UILabel!
    @IBOutlet weak var favoritesImageView: UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func setConstraints() {
        let title = favoritesTitleLabel
        let subtitle = favoritesSubtitleLabel
        let imageView = favoritesImageView
        imageView?.frame = .init(x: 0, y: 30, width: 100, height: 100)
        title?.frame = .init(x: 0, y: 0, width: superview!.frame.width, height: 30)
        subtitle?.frame = .init(x: 100, y: 30, width: (superview!.frame.width - 100), height: 100)
    }
}
