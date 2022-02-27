//
//  NewsTableViewCell.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    private let linkLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    public var urlBrowserString = ""
    private var likeButtonCounter = 1
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showMoreAdd()
        setConstrains()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
    }
    /* настройка UI для лейбы с заголовком */
    private func newsTitleLabelSetup() {
        let label = newsTitleLabel
        label?.frame = .init(x: 0, y: 0, width: superview!.frame.width, height: 30)
    }
    /* настройка UI для лейбы с описанием */
    private func newsDescriptionLabelSetup() {
        let label = newsDescriptionLabel
        label?.sizeToFit()
        label?.lineBreakMode = .byWordWrapping
        label?.adjustsFontSizeToFitWidth = true
        label?.textAlignment = .left
        label?.numberOfLines = 0
        label?.sizeToFit()
        label?.frame = .init(x: 100, y: 30, width: (superview!.frame.width - 100), height: 100)
    }
    /* настройка UI для imageView */
    private func newsImageViewSetup() {
        let imageView = newsImageView
        imageView?.frame = .init(x: 0, y: 30, width: 100, height: 100)
    }
    /* настройка UI для лейбы, которая покрывает подпись "... Show More" */
    private func linkLabelSetup() {
        let label = linkLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        newsDescriptionLabel.addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: newsDescriptionLabel.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: newsDescriptionLabel.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: newsDescriptionLabel.trailingAnchor, constant: -newsDescriptionLabel.frame.width/1.3),
            label.topAnchor.constraint(equalTo: newsDescriptionLabel.bottomAnchor, constant: -20)
        ])
    }
    /* настройка UI для кнопки добавления в избранное*/
    private func likeButtonSetup() {
        let button = likeButton
        let imageView = newsImageView
        let image = UIImage(named: "save")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(addToFavoritesTapped), for: .touchUpInside)
        newsDescriptionLabel.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: newsDescriptionLabel.topAnchor),
            button.leadingAnchor.constraint(equalTo: newsDescriptionLabel.trailingAnchor, constant: -imageView!.frame.width/2),
            button.trailingAnchor.constraint(equalTo: newsDescriptionLabel.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: newsDescriptionLabel.topAnchor, constant: imageView!.frame.height/2)
        ])
    }
    /* настройка UI элементов ячейки во вкладке News*/
    private func setConstrains() {
        newsTitleLabelSetup()
        newsDescriptionLabelSetup()
        newsImageViewSetup()
        likeButtonSetup()
        linkLabelSetup()
    }
    /* добавление подписи "... Read More" (функция лежит в Utility)в конец описания при условии количества строк до 3х */
    private func showMoreAdd() {
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
    /* преобразование изображения из типа UIImage в Data */
    private func convertImageToData(_ img: UIImage) -> Data {
        guard let data = img.jpegData(compressionQuality: 0.5) else { return UIImage(named: "noImage")!.jpegData(compressionQuality: 0.5)!}
        let encoded = try! PropertyListEncoder().encode(data)
        return encoded
    }
}

extension NewsTableViewCell {
    //    MARK: - IBActions
    /* функция, вызываемая при нажатии на кнопку добавления в избранное */
    @objc func addToFavoritesTapped() {
        let button = likeButton
        likeButtonCounter += 1
        if likeButtonCounter%2 == 0 {
            /* добавление ячейки в избранное и перекрашивание кнопки */
            NewsViewController.shared.favoritesImage.append(convertImageToData((newsImageView.image ?? UIImage(named: "noImage"))!))
            NewsViewController.shared.favoritesTitle.append(newsTitleLabel.text!)
            NewsViewController.shared.favoritesSubtitle.append(newsDescriptionLabel.text!)
            button.tintColor = .red
        } else {
            /* удаление ячейки из избранного и перекрашивание кнопки */
            let index = NewsViewController.shared.favoritesTitle.firstIndex(of: "\(newsTitleLabel.text!)")
            NewsViewController.shared.favoritesTitle.remove(at: index!)
            NewsViewController.shared.favoritesImage.remove(at: index!)
            NewsViewController.shared.favoritesSubtitle.remove(at: index!)
            button.tintColor = .blue
        }
    }
    /* функция, вызываемая при регистрации Tap жеста в обоасти подписи "... Read More" */
    @objc func tapGestureTapped() {
        print("GESTURE TAPPED")
        newsDescriptionLabel.lineBreakMode = .byWordWrapping
        newsDescriptionLabel.textAlignment = .left
        /* изменение размера лейбы с описанием */
        newsDescriptionLabel.frame = .init(x: 100, y: 30, width: (superview!.frame.width - 100), height: 150)
    }
}
