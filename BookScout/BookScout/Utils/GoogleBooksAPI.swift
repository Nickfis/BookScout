//
//  GoogleBooksAPI.swift
//  BookScout
//
//  Created by Niklas Fischer on 17/6/23.
//

import Foundation

struct GoogleBooksAPI {
    let url = URL(string: "https://www.googleapis.com/books/v1/volumes")!

    func getBookInformation(searchTerm: String, completion: @escaping (Book?, Error?) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "maxResults", value: "1"),
        ]

        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                    if let item = result.items.first {
                        let book = Book(
                            title: item.volumeInfo.title,
                            subtitle: item.volumeInfo.subtitle,
                            authors: item.volumeInfo.authors?.joined(separator: ", ") ?? " ",
                            description: item.volumeInfo.description,
                            averageRating: item.volumeInfo.averageRating,
                            ratingsCount: item.volumeInfo.ratingsCount,
                            pageCount: item.volumeInfo.pageCount
                        )
                        completion(book, nil)
                    } else {
                        completion(nil, nil)
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
}

struct Book: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let authors: String
    let description: String?
    let averageRating: Double?
    let ratingsCount: Int?
    let pageCount: Int?
}

struct GoogleBooksResponse: Codable {
    let items: [GoogleBooksItem]
}

struct GoogleBooksItem: Codable {
    let volumeInfo: VolumeInfo

    struct VolumeInfo: Codable {
        let title: String
        let subtitle: String?
        let authors: [String]?
        let description: String?
        let averageRating: Double?
        let ratingsCount: Int?
        let pageCount: Int?
    }
}
