//
//  NetworkManager.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    /* функция загрузки и декодирования JSON */
    public func loadDataByApi(date: String, completionHandler: @escaping (Swift.Result<[Article], Error>) -> Void ) {
        /* в url подставляется дата новостей, которую мы передаем на вход функции уже стрингом */
        let apiStringUrl = "https://newsapi.org/v2/everything?q=apple&from=\(date)&to=\(date)&sortBy=popularity&apiKey=fd1573ac039c49a591c1885212a94d9d"
        guard let url = URL(string: apiStringUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let results = try JSONDecoder().decode(Result.self, from: data)
                completionHandler(.success(results.articles))
            } catch {
                completionHandler(.failure(error))
                print(error.localizedDescription)
            }
        }.resume()
    }
}
