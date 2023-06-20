//
//  DetailedBookView.swift
//  BookScout
//
//  Created by Niklas Fischer on 18/6/23.
//

import SwiftUI

struct DetailedBookView: View {
    let book: Book
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .offset(x: -50)
            VStack {
                ScrollView {
                    VStack {
                        Text(book.title).font(.title)
                        if let subtitle = book.subtitle {
                            Text(subtitle).font(.title2)
                        }
                        
                        Text("By \(book.authors)").font(.subheadline)
                        HStack {
                            if let pageCount = book.pageCount {
                                Text("Pages: \(pageCount)")
                            }
                            Spacer()
                            VStack {
                                if let averageRating = book.averageRating {
                                    HStack {
                                        Text(String(format: "%.1f", averageRating))
                                        Image(systemName: "star.fill").foregroundColor(Color.red.opacity(0.6))
                                    }
                                }
                                if let ratingsCount = book.ratingsCount {
                                    Text("\(ratingsCount) Ratings")
                                }
                            }
                        }.padding([.horizontal, .top, .bottom])
                        .background(Color.clear)
                        
                        if let description = book.description {
                            Text(description)
                        }
                    }
                    .background(Color.clear)
                }
                .padding([.horizontal, .vertical])
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .background(Color.white.opacity(0.85))
                .cornerRadius(10)
            }.padding(.vertical)
        }
    }
}

struct DetailedBookView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedBookView(book: Book(title: "Sample Book with a long title to see what happens", subtitle: "A Great Book", authors: "John Doe", description: "Fascinating . . . If you’re a generalist who has ever felt overshadowed by your specialist colleagues, this book is for you' – Bill Gates The instant Sunday Times Top Ten and New York Times bestseller Shortlisted for the Financial Times/McKinsey Business Book of the Year Award A Financial Times Essential Reads A powerful argument for how to succeed in any field: develop broad interests and skills while everyone around you is rushing to specialize. From the ‘10,000 hours rule’ to the power of Tiger parenting, we have been taught that success in any field requires early specialization and many hours of deliberate practice. And, worse, that if you dabble or delay, you'll never catch up with those who got a head start. This is completely wrong. In this landmark book, David Epstein shows you that the way to succeed is by sampling widely, gaining a breadth of experiences, taking detours, experimenting relentlessly, juggling many interests – in other words, by developing range. Studying the world's most successful athletes, artists, musicians, inventors and scientists, Epstein demonstrates why in most fields – especially those that are complex and unpredictable – generalists, not specialists are primed to excel. No matter what you do, where you are in life, whether you are a teacher, student, scientist, business analyst, parent, job hunter, retiree, you will see the world differently after you've read Range. You'll understand better how we solve problems, how we learn and how we succeed. You'll see why failing a test is the best way to learn and why frequent quitters end up with the most fulfilling careers. As experts silo themselves further while computers master more of the skills once reserved for highly focused humans, Range shows how people who think broadly and embrace diverse experiences and perspectives will increasingly thrive and why spreading your knowledge across multiple domains is the key to your success, and how to achieve it. 'I loved Range' – Malcolm Gladwell 'Urgent and important. . . an essential read for bosses, parents, coaches, and anyone who cares about improving performance.' – Daniel H. Pink 'So much crucial and revelatory information about performance, success, and education.' – Susan Cain, bestselling author of Quiet", averageRating: 4.5, ratingsCount: 100, pageCount: 200))
    }
}
