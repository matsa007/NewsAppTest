//
//  ViewController.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit
import SafariServices
import Kingfisher

final class NewsViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
    private let defaults = UserDefaults.standard
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet var newsSearchBar: UISearchBar!
    static var shared = NewsViewController()
    var articles: [Article] = []
    let searchController = UISearchController()
    var filteredArticles = [Article]()
    let newsTableViewCell = NewsTableViewCell()
    let refreshControl = UIRefreshControl()
    let totaysDate = Date()
    var paginationCouner = 0
    var isLoading = false
    
    var favoritesTitle: Array <String> {
        set {
            defaults.set(newValue, forKey: "title")
        }
        
        get {
            defaults.object(forKey: "title") as? [String] ?? []
        }
    }
    
    var favoritesSubtitle: Array <String> {
        set {
            defaults.set(newValue, forKey: "subtitle")
        }
        
        get {
            defaults.object(forKey: "subtitle") as? [String] ?? []
        }
    }
    
    var favoritesImage: Array <Data> {
        set {
            defaults.set(newValue, forKey: "img")
        }
        
        get {
            defaults.object(forKey: "img") as? [Data] ?? []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        loadNews(dateForNews: totaysDate)
        refreshSetup()
        searchControllerSetup()
    }
    
    func searchControllerSetup() {
        let search = searchController
        search.loadViewIfNeeded()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.enablesReturnKeyAutomatically = false
        search.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text
        filterForSearchText(searchText: searchText!)
    }
    
    func filterForSearchText(searchText: String) {
        filteredArticles = articles.filter {
            article in
            if searchController.searchBar.text != "" {
                let searchTextMatchTitle = article.title.lowercased().contains(searchText.lowercased())
                return searchTextMatchTitle
            } else {
                return true
            }
        }
        newsTableView.reloadData()
    }
    
    func refreshSetup() {
        if #available(iOS 10.0, *) {
            newsTableView.refreshControl = refreshControl
        } else {
            newsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshNewsData(_:)), for: .valueChanged)
        let font = UIFont.systemFont(ofSize: 20)
        let color = UIColor(red:23/255, green:56/255, blue:135/255, alpha:1.0)
        refreshControl.tintColor = color
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        refreshControl.attributedTitle = NSAttributedString(string: "Updating news ...", attributes: attributes)
    }
    
    //    алерт
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loadNews(dateForNews: Date) {
        DispatchQueue.global(qos: .userInitiated).async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateForNewsString = dateFormatter.string(from: dateForNews)
            print("DATE FOR NEWS FOR LOAD === \(dateForNewsString)")
            NetworkManager.shared.loadDataByApi(date: dateForNewsString) { [weak self] result in
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
    
    @objc private func refreshNewsData(_ sender: Any) {
        loadNews(dateForNews: totaysDate)
        self.newsTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredArticles.count
        } else {
            return articles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell else { return UITableViewCell() }
        let article = articles[indexPath.row]
        if searchController.isActive {
            let filteredArticles = filteredArticles[indexPath.row]
            cell.newsTitleLabel.text = filteredArticles.title
            cell.newsDescriptionLabel.text = filteredArticles.description
            let placeholderImage = UIImage(named: "noImage")
            let processor = DownsamplingImageProcessor(size: cell.newsImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
            cell.newsImageView.kf.indicatorType = .activity
            if let urlToImage = filteredArticles.urlToImage, let url = URL(string: urlToImage) {
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
        } else {
            cell.newsTitleLabel.text = article.title
            cell.newsDescriptionLabel.text = article.description
            let placeholderImage = UIImage(named: "noImage")
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
        }
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
        140
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height

                if (offsetY > (self.newsTableView.contentSize.height-scrollView.frame.size.height+100)) && !isLoading {
                    paginationCouner += 1
                    loadMoreData()
                }
    }
    
    func loadMoreData() {
            if !self.isLoading {
                self.isLoading = true
                DispatchQueue.global().async {
                    let minus24HoursDate = Calendar.current.date(byAdding: .day, value: -self.paginationCouner, to: self.totaysDate)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        let dateForNewsString = dateFormatter.string(from: minus24HoursDate ?? Date())
                    sleep(2)
                    if self.paginationCouner > 7 {
                        return
                    }
                    print(dateForNewsString)
                    NetworkManager.shared.loadDataByApi(date: dateForNewsString) { [weak self] result in
                                           switch result {
                                           case .success(let articles):
                                               DispatchQueue.main.async {
                                                   self?.articles.append(contentsOf: articles)
                                                   self?.newsTableView.reloadData()
                                               }
                                           case .failure(let error):
                                               DispatchQueue.main.async {
                                                   self?.showError(error)
                                               }
                                           }
                                       }
                    DispatchQueue.main.async {
                        self.newsTableView.reloadData()
                        self.isLoading = false
                    }
                }
            }
        }
}



