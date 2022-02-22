//
//  Article.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 22.02.2022.
//

import Foundation

struct Result: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
