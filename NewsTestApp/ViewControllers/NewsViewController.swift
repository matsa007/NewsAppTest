//
//  ViewController.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit

final class NewsViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    var articles = [Article]()
    var newsViewModel = [NewsTableViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        DispatchQueue.main.async {
            NetworkManager.shared.loadDataByApi { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.newsViewModel = articles.compactMap({
                        NewsTableViewCellModel(title: $0.title,
                                               subTitle: $0.description,
                                               imageUrl: URL(string: $0.urlToImage ?? "https://static.thenounproject.com/png/2884221-200.png")!,
                                               contentUrl: $0.content, publishedAt: $0.publishedAt)
                    })
                    DispatchQueue.main.async {
                        self?.newsTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsViewModel.count
        //        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell else { return UITableViewCell() }
        cell.configure(model: newsViewModel[indexPath.row])
        //        cell.newsTitleLabel.text = "Demo Title"
        //        cell.newsDescriptionLabel.text = "Demo Description"
        //        cell.newsImageView.image = UIImage(named: "EUR")
        return cell
    }
    
    
}

