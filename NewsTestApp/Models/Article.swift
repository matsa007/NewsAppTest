//
//  Article.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import Foundation
/* корневые ключи JSON */
struct Result: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
/* значения ключа articles */
struct Article: Codable {
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
}
