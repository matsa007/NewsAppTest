//
//  NetworkManager.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    
//    функция загрузки и декодирования JSON
    func loadDataByApi(date: Date, completionHandler: @escaping (Swift.Result<[Article], Error>) -> Void ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let todayDateString = dateFormatter.string(from: date)
        let apiStringUrl = "https://newsapi.org/v2/everything?q=apple&from=\(todayDateString)&to=\(todayDateString)&sortBy=popularity&apiKey=adf5882279984198ac2a9542ac6eb879"
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
