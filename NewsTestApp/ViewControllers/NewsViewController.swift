//
//  ViewController.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import UIKit

final class NewsViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        DispatchQueue.main.async {
            NetworkManager.shared.loadDataByApi()
        }
        
    }


}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell else { return UITableViewCell() }
        cell.newsTitleLabel.text = "Demo Title"
        cell.newsDescriptionLabel.text = "Demo Description"
        cell.newsImageView.image = UIImage(named: "EUR")
        return cell
    }
    
    
}

