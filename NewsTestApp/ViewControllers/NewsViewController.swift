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
    
    var favoritesTitle: Array <String> = [] {
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
    
    var favoritesImage: Array <UIImage> = [] {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
//    func reloadFilterData(shouldReloadTableView: Bool = true) {
//        if let searchBarText = searchBarText {
////            filterDataSource(<#T##filterText: String##String#>, <#T##model: NewsTableViewCellModel##NewsTableViewCellModel#>)
////            for element in newsViewModel {
////                filterDataSource(searchBarText, element)
////            }
//
//        } else {
//            resetDataSource()
//        }
//
//        if shouldReloadTableView {
//            newsTableView.reloadData()
//        }
//    }
    
//    private func filterDataSource(_ filterText: String, _ model: NewsTableViewCellModel) {
//        if filterText.count > 0 {
//            filteredTitle = [model.title].filter {
//                $0.lowercased().contains(filterText.lowercased())
//            }
//
//            filteredDescription = [model.subTitle].filter {
//                $0.lowercased().contains(filterText.lowercased())
//            }
//        } else {
//            resetDataSource()
//        }
//    }
//
//    func resetDataSource() {
//        //        filteredMen = men
//        //        filteredWomen = women
//    }

    
    func loadNews() {
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.shared.loadDataByApi(date: Date()) { [weak self] result in
                switch result {
                case .success(let articles):
                    DispatchQueue.main.async {
                        self?.articles = articles
                        self?.newsTableView.reloadData()
                    }
                    
//                    self?.newsViewModel = articles.compactMap({
//                        NewsTableViewCellModel(title: $0.title,
//                                               subTitle: $0.description,
//                                               imageUrl: URL(string: $0.urlToImage ?? "https://static.thenounproject.com/png/2884221-200.png")!,
//                                               contentUrl: $0.content, publishedAt: $0.publishedAt)
//                    })
                    
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
//        cell.configure(model: newsViewModel[indexPath.row])
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
     
       
        //        tableView.reloadRows(at: [indexPath], with: .automatic)
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

