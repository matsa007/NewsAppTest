//
//  NetworkManager.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    let apiStringUrl = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=adf5882279984198ac2a9542ac6eb879"
    func loadDataByApi() {
        guard let url = URL(string: apiStringUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let results = try JSONDecoder().decode(Result.self, from: data)
                print(results.articles)
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
