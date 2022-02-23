//
//  NewsTableViewCell.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: NewsTableViewCellModel) {
        newsTitleLabel.text = model.title
        newsDescriptionLabel.text = model.subTitle
        if let data = model.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = model.imageUrl {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
