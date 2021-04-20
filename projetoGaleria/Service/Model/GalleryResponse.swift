//
//  GalleryResponse.swift
//  projetoGaleria
//
//  Created by Bruno Rocha on 20/04/21.
//

import Foundation

struct GalleryResponse: Decodable {
    let data: [DataResponse]
    let success: Bool
    let status: Int

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case success = "success"
        case status = "status"
    }
}

struct DataResponse: Decodable {
    let images: [GalleryImage]?
}

struct GalleryImage: Decodable {
    let id: String
    let link: String
}

