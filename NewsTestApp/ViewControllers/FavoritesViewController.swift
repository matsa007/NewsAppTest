//
//  FavoritesViewController.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit

final class FavoritesViewController: UIViewController {
    static var shared = FavoritesViewController()

    @IBOutlet weak var favoritesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        favoritesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesTableView.reloadData()
        print("will appear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
  
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(NewsViewController.shared.favoritesTitle.count)
        return NewsViewController.shared.favoritesTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as? FavoritesTableViewCell
        cell?.favoritesTitleLabel.text = NewsViewController.shared.favoritesTitle[indexPath.row]
        cell?.favoritesSubtitleLabel.text = NewsViewController.shared.favoritesSubtitle[indexPath.row]
        cell?.favoritesImageView.image = NewsViewController.shared.favoritesImage[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    
    
    
}
