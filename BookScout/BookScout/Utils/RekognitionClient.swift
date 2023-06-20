//
//  RekognitionClient.swift
//  BookScout
//
//  Created by Niklas Fischer on 17/6/23.
//

import Foundation
import SotoRekognition


func getRekognitionClient() -> Rekognition {
    let awsAccessKey = Bundle.main.infoDictionary?["AWS_ACCESS_KEY"] as! String
    let awsSecretKey = Bundle.main.infoDictionary?["AWS_SECRET_ACCESS_KEY"] as! String
    let awsClient = AWSClient(
        credentialProvider: .static(accessKeyId: awsAccessKey, secretAccessKey: awsSecretKey),
        httpClientProvider: .createNew
    )
    return Rekognition(client: awsClient, region: .useast1)
}
