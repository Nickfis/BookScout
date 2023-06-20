//
//  BookTile.swift
//  BookScout
//
//  Created by Niklas Fischer on 18/6/23.
//

import SwiftUI

struct BookTile: View {
    var book: Book
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title).font(book.title.count > 30 ? .title2 : .title)
                Text("By \(book.authors)").font(.subheadline)
            }
            Spacer()
            VStack {
                if let averageRating = book.averageRating, let ratingsCount = book.ratingsCount {
                    HStack {
                        Text(String(format: "%.1f", averageRating))
                        Image(systemName: "star.fill").foregroundColor(Color.red.opacity(0.6))
                    }
                    Text("(\(ratingsCount))")
                } else {
                    Text("No ratings")
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.85)
        .background(Color.white.opacity(0.85))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        .padding(.top)
    }
}
