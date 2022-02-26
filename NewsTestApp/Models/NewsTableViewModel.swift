//
//  NewsTableViewModel.swift
//  NewsTestApp
//
//  Created by Сергей Матвеенко on 23.02.2022.
//

import Foundation

/*под вопросом нужды?????*/
class NewsTableViewCellModel {
    let title: String
    let subTitle: String
    let imageUrl: URL?
    let contentUrl: String
    let publishedAt: String
    var imageData: Data? = nil
    
    init(title: String, subTitle: String, imageUrl: URL?, contentUrl: String, publishedAt: String) {
        self.title = title
        self.subTitle = subTitle
        self.imageUrl = imageUrl
        self.contentUrl = contentUrl
        self.publishedAt = publishedAt
    }
}
