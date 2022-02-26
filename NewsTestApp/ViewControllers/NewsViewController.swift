//
//  ViewController.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit
import SafariServices
import Kingfisher

final class NewsViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet var newsSearchBar: UISearchBar!
    static var shared = NewsViewController()
    var articles: [Article] = []
    let newsTableViewCell = NewsTableViewCell()
    lazy var favoritesTitle: Array <String> = [] {
        didSet {
            print(favoritesTitle)
        }
    }
    
    lazy var favoritesSubtitle: Array <String> = [] {
        didSet {
            DispatchQueue.main.async {
                
                print(self.favoritesSubtitle)
            }
        }
    }
    
    lazy var favoritesImage: Array <UIImage> = [] {
        didSet {
            print(favoritesImage)
        }
    }
    
    var searchBarText: String? {
        didSet {
            print(searchBarText!)
            print(filteredTitle)
            print(filteredDescription)
            //            reloadFilterData()
        }
    }
    var filteredTitle: [String] = []
    var filteredDescription: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        loadNews()
        navigationItem.titleView = newsSearchBar
        newsSearchBar.delegate = self
    }
    //    алерт
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loadNews() {
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.shared.loadDataByApi(date: Date()) { [weak self] result in
                switch result {
                case .success(let articles):
                    DispatchQueue.main.async {
                        self?.articles = articles
                        self?.newsTableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showError(error)
                    }
                }
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell else { return UITableViewCell() }
        let article = articles[indexPath.row]
        cell.newsTitleLabel.text = article.title
        cell.newsDescriptionLabel.text = article.description
        let placeholderImage = UIImage(named: "EUR")
        let processor = DownsamplingImageProcessor(size: cell.newsImageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.newsImageView.kf.indicatorType = .activity
        if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
            cell.newsImageView.kf.setImage(
                with: url,
                placeholder: placeholderImage,
                options: [
                    .processor(processor),
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.25)),
                ],
                progressBlock: { receivedSize, totalSize in
                    // Progress updated
                },
                completionHandler: { result in
                    // Done
                }
            )
        } else {
            cell.newsImageView.image = placeholderImage
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        newsTableViewCell.urlBrowserString = article.url
        guard let url = URL(string: article.url) else { return }
        let browserViewController = SFSafariViewController(url: url)
        present(browserViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
    }
}

