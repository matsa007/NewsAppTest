//
//  NewsTableViewCell.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    var urlBrowserString = ""
    var counter = 1
    let linkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.backgroundColor = .clear
        return label
    }()
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "save")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addToFavoritesTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showMoreAdd()
        setConstrains()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
    }
    
    
    func setConstrains() {
        let linkLabel = linkLabel
        let descriptionLabel = newsDescriptionLabel
        let titleLabel = newsTitleLabel
        let imageView = newsImageView
        let button = likeButton
        descriptionLabel!.sizeToFit()
        //        descriptionLabel?.lineBreakMode = .byWordWrapping
        
        descriptionLabel?.adjustsFontSizeToFitWidth = true
        descriptionLabel?.textAlignment = .left
        descriptionLabel?.lineBreakMode = .byWordWrapping
        descriptionLabel?.numberOfLines = 0
        descriptionLabel?.sizeToFit()
        descriptionLabel?.addSubview(linkLabel)
        descriptionLabel?.addSubview(button)
        
        titleLabel?.frame = .init(x: 0, y: 0, width: superview!.frame.width, height: 30)
        imageView?.frame = .init(x: 0, y: 30, width: 100, height: 100)
        descriptionLabel?.frame = .init(x: 100, y: 30, width: (superview!.frame.width - 150), height: 100)
        NSLayoutConstraint.activate([
            linkLabel.bottomAnchor.constraint(equalTo: descriptionLabel!.bottomAnchor),
            linkLabel.trailingAnchor.constraint(equalTo: descriptionLabel!.trailingAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: descriptionLabel!.trailingAnchor, constant: -descriptionLabel!.frame.width/1.3),
            linkLabel.topAnchor.constraint(equalTo: descriptionLabel!.bottomAnchor, constant: -20)
        ])
       
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: descriptionLabel!.topAnchor),
            button.leadingAnchor.constraint(equalTo: descriptionLabel!.trailingAnchor, constant: -imageView!.frame.width/2),
            button.trailingAnchor.constraint(equalTo: descriptionLabel!.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: descriptionLabel!.topAnchor, constant: imageView!.frame.height/2)
        ])
        
    }
    
    func showMoreAdd() {
        let label = newsDescriptionLabel
        let linkLabel = linkLabel
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped)))
        let readmoreFont = UIFont(name: "Tamil Sangam MN Bold", size: 11.0)
        let readmoreFontColor = UIColor.blue
        DispatchQueue.main.async {
            if label!.numberOfLines <= 3 {
                label!.addTrailing(with: "... ", moreText: "Read more", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
            }
        }
    }
    
    @objc func addToFavoritesTapped() {
        let button = likeButton
        counter = counter + 1
        if counter%2 == 0 {
            NewsViewController.shared.favoritesImage.append(convertImageToData((newsImageView.image ?? UIImage(named: "EUR"))!))
            NewsViewController.shared.favoritesTitle.append(newsTitleLabel.text!)
            NewsViewController.shared.favoritesSubtitle.append(newsDescriptionLabel.text!)
            button.tintColor = .red
        } else {
            let index = NewsViewController.shared.favoritesTitle.firstIndex(of: "\(newsTitleLabel.text!)")
            NewsViewController.shared.favoritesTitle.remove(at: index!)
            NewsViewController.shared.favoritesImage.remove(at: index!)
            NewsViewController.shared.favoritesSubtitle.remove(at: index!)
            button.tintColor = .white
        }
    }
    
    func convertImageToData(_ img: UIImage) -> Data {
        guard let data = img.jpegData(compressionQuality: 0.5) else { return UIImage(named: "EUR")!.jpegData(compressionQuality: 0.5)!}
        let encoded = try! PropertyListEncoder().encode(data)
        return encoded
    }
    
    @objc func tapGestureTapped() {
        print("GESTURE TAPPED")
//        NewsViewController.shared.favoritesImage.append(convertImageToData((newsImageView.image ?? UIImage(named: "EUR"))!))
//        NewsViewController.shared.favoritesTitle.append(newsTitleLabel.text!)
//        NewsViewController.shared.favoritesSubtitle.append(newsDescriptionLabel.text!)
        
        newsDescriptionLabel.backgroundColor = .green
        print(newsTitleLabel.text ?? "No text")
                newsDescriptionLabel.lineBreakMode = .byWordWrapping
//        newsDescriptionLabel.numberOfLines -= 1
        newsDescriptionLabel.frame = .init(x: 100, y: 30, width: (superview!.frame.width - 100), height: 150)
        newsDescriptionLabel.textAlignment = .left
        print("NEW NUMBER OF LINES = \(newsDescriptionLabel.numberOfLines)")
        
    }
}
