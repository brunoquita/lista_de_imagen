//
//  File.swift
//  projetoGaleria
//
//  Created by Bruno Rocha on 20/04/21.
//

import Foundation
import UIKit

class GallerySearchService {

    public enum Constants {
        static let serachGalleryBaseUrl = "https://api.imgur.com/3/gallery/search"

        static let contentTypeHeader = "Content-Type"
        static let authorizationHeader = "Authorization"

        static let contentTypeValue = "application/json"
        static let authorizationValue = "Client-ID 1ceddedc03a5d71"
    }

    public func getImages(search: String, page: Int, completion: @escaping (GalleryResponse) -> Void) {
        guard let url = URL(string: "\(Constants.serachGalleryBaseUrl)/\(page)?q=\(search)&q_size_px=small&q_type=jpg") else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(Constants.contentTypeValue, forHTTPHeaderField: Constants.contentTypeHeader)
        urlRequest.addValue(Constants.authorizationValue, forHTTPHeaderField: Constants.authorizationHeader)

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            guard let galeryResponse = try? JSONDecoder().decode(GalleryResponse.self, from: data) else {
                return
            }
            completion(galeryResponse)
        }
        task.resume()
    }

    public func downloadImage(with link: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: link) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
}

