//
//  FavoritesViewController.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit
import SafariServices

final class FavoritesViewController: UIViewController {
    static var shared = FavoritesViewController()
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesTableView.reloadData()
    }
    /* преобразование изображения из типа Data в UIImage */
    private func convertImageFromData(_ dataImg: Data?) -> UIImage {
        guard let data = dataImg else { return UIImage(named: "noImage")! }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded)
        return image ?? UIImage(named: "noImage")!
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - настройка таблицы
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NewsViewController.shared.favoritesTitle.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as? FavoritesTableViewCell
        DispatchQueue.main.async {
            cell?.favoritesTitleLabel.text = NewsViewController.shared.favoritesTitle[indexPath.row]
            cell?.favoritesSubtitleLabel.text = NewsViewController.shared.favoritesSubtitle[indexPath.row]
            cell?.favoritesImageView.image = self.convertImageFromData(NewsViewController.shared.favoritesImage[indexPath.row])
        }
        return cell!
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    internal func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoritesTableView.beginUpdates()
            NewsViewController.shared.favoritesTitle.remove(at: indexPath.row)
            NewsViewController.shared.favoritesImage.remove(at: indexPath.row)
            NewsViewController.shared.favoritesSubtitle.remove(at: indexPath.row)
            favoritesTableView.deleteRows(at: [indexPath], with: .fade)
            favoritesTableView.endUpdates()
        }
    }
}
