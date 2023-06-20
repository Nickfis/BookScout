//
//  RekognitionUtils.swift
//  BookScout
//
//  Created by Niklas Fischer on 17/6/23.
//
import Foundation
import SotoRekognition

struct RekognitionUtils {
    var awsClient: AWSClient
    var rekognition: Rekognition
    
    init() {
        let awsAccessKey = Bundle.main.infoDictionary?["AWS_ACCESS_KEY"] as! String
        let awsSecretKey = Bundle.main.infoDictionary?["AWS_SECRET_ACCESS_KEY"] as! String
        print("AWS access key \(awsAccessKey)")
        print("AWS Secret Key \(awsSecretKey)")
        self.awsClient = AWSClient(
            credentialProvider: .static(accessKeyId: awsAccessKey, secretAccessKey: awsSecretKey),
            httpClientProvider: .createNew
        )
        self.rekognition = Rekognition(client: awsClient, region: .useast1)
    }

    func shutdown() {
        try? self.awsClient.syncShutdown()
    }

    func analyzeImage(imageData: Data, completion: @escaping ([String]?, Error?) -> Void) {
        let base64String = imageData.base64EncodedString()
        let base64Data = AWSBase64Data.base64(base64String)
        
        let image = Rekognition.Image(bytes: base64Data)

        // Detect labels
        let detectLabelsRequest = Rekognition.DetectLabelsRequest(image: image, maxLabels: 10)
        let labelsFuture = self.rekognition.detectLabels(detectLabelsRequest)

        // Detect text
        let detectTextRequest = Rekognition.DetectTextRequest(image: image)
        print("Going to make the API request now")
        let textFuture = self.rekognition.detectText(detectTextRequest)

        let combinedFuture = labelsFuture.and(textFuture)

        combinedFuture.whenSuccess { (labelsResponse, textResponse) in
            guard let allBooks = labelsResponse.labels?.first(where: { $0.name == "Book" })?.instances else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No books found"]))
                return
            }
            guard let allTexts = textResponse.textDetections else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No texts found"]))
                return
            }

            // More processing...
            var allBookInfo: [String] = []
            for book in allBooks {
                let bookBox = book.boundingBox
                var textObjects: [String] = []
                for text in allTexts {
                    let textBox = text.geometry?.boundingBox
                    if isTextInBox(text: textBox, box: bookBox), let detectedText = text.detectedText, detectedText.count > 3 {
                        textObjects.append(detectedText)
                    }
                }
                let uniqueTexts = Array(Set(textObjects.joined(separator: " ").components(separatedBy: " "))).sorted()
                allBookInfo.append(uniqueTexts.joined(separator: " "))
            }
            completion(allBookInfo, nil)

        }

        combinedFuture.whenFailure { error in
            print("There has been an error buddy")
            print(error)
            // Handle error
            completion(nil, error)
        }
    }

    private func isTextInBox(text: Rekognition.BoundingBox?, box: Rekognition.BoundingBox?) -> Bool {
        guard let text = text, let box = box,
              let textLeft = text.left, let textTop = text.top, let textBoxWidth = text.width, let textBoxHeight = text.height,
              let boxLeft = box.left, let boxTop = box.top, let boxWidth = box.width, let boxHeight = box.height else {
            return false
        }
        return textLeft >= boxLeft &&
            textTop >= boxTop &&
            (textLeft + textBoxWidth) <= (boxLeft + boxWidth) &&
            (textTop + textBoxHeight) <= (boxTop + boxHeight)
    }
}
