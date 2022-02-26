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
        imageView?.frame = .init(x: 0, y: 0, width: 200, height: 200 )
        title?.frame = .init(x: 200, y: 0, width: superview!.frame.width, height: 100)
        subtitle?.frame = .init(x: 200, y: 100, width: superview!.frame.width, height: 100)
    }
}
