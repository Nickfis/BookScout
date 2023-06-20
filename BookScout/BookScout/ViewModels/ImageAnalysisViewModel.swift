import Foundation
import UIKit


class ImageAnalysisViewModel: ObservableObject {
    private var rekognitionUtils: RekognitionUtils?
    private let googleBooksAPI = GoogleBooksAPI()

    @Published var isLoading = false
//    @Published var results: [Book] = []
    @Published var results = [Book(title: "Sample Book with a long title to see what happens", subtitle: "A Great Book", authors: "John Doe", description: "Fascinating . . . If you’re a generalist who has ever felt overshadowed by your specialist colleagues, this book is for you' – Bill Gates The instant Sunday Times Top Ten and New York Times bestseller Shortlisted for the Financial Times/McKinsey Business Book of the Year Award A Financial Times Essential Reads A powerful argument for how to succeed in any field: develop broad interests and skills while everyone around you is rushing to specialize. From the ‘10,000 hours rule’ to the power of Tiger parenting, we have been taught that success in any field requires early specialization and many hours of deliberate practice. And, worse, that if you dabble or delay, you'll never catch up with those who got a head start. This is completely wrong. In this landmark book, David Epstein shows you that the way to succeed is by sampling widely, gaining a breadth of experiences, taking detours, experimenting relentlessly, juggling many interests – in other words, by developing range. Studying the world's most successful athletes, artists, musicians, inventors and scientists, Epstein demonstrates why in most fields – especially those that are complex and unpredictable – generalists, not specialists are primed to excel. No matter what you do, where you are in life, whether you are a teacher, student, scientist, business analyst, parent, job hunter, retiree, you will see the world differently after you've read Range. You'll understand better how we solve problems, how we learn and how we succeed. You'll see why failing a test is the best way to learn and why frequent quitters end up with the most fulfilling careers. As experts silo themselves further while computers master more of the skills once reserved for highly focused humans, Range shows how people who think broadly and embrace diverse experiences and perspectives will increasingly thrive and why spreading your knowledge across multiple domains is the key to your success, and how to achieve it. 'I loved Range' – Malcolm Gladwell 'Urgent and important. . . an essential read for bosses, parents, coaches, and anyone who cares about improving performance.' – Daniel H. Pink 'So much crucial and revelatory information about performance, success, and education.' – Susan Cain, bestselling author of Quiet", averageRating: 4.5, ratingsCount: 100, pageCount: 200)]

    @Published var error: Error?

    func loadImage(from inputImage: UIImage?) {
        if let img = inputImage {
            if let imageData = img.jpegData(compressionQuality: 0.6) {
                isLoading = true
                rekognitionUtils = RekognitionUtils()
                rekognitionUtils?.analyzeImage(imageData: imageData) { [weak self] (results, error) in
                    DispatchQueue.main.async {
                        self?.rekognitionUtils?.shutdown()
                        self?.rekognitionUtils = nil

                        if let results = results {
                            self?.fetchBookInformation(for: results)
                            
                        } else {
                            self?.isLoading = false
                            self?.error = error
                        }
                    }
                }
            }
        } else {
            // If image not found, handle the error appropriately.
            print("No image selected from camera")
        }
    }

    func fetchBookInformation(for searchTerms: [String]) {
        let group = DispatchGroup()

        for searchTerm in searchTerms {
            group.enter()

            googleBooksAPI.getBookInformation(searchTerm: searchTerm) { [weak self] (book, error) in
                defer { group.leave() }

                if let error = error {
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.error = error
                    }
                } else if let book = book {
                    DispatchQueue.main.async {
                        self?.results.append(book)
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.results.sort(by: { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) })
            self?.isLoading = false
            print("All books fetched")
        }
    }

    func clearResults() {
        self.results = []
    }
}


