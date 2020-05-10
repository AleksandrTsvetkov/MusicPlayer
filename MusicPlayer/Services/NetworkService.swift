//
//  NetworkService.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 07.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "limit": "10", "media": "music"]
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil).responseData { dataResponse in
            guard dataResponse.error == nil else {
                print("Error in \(#function) -> \(dataResponse.error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = dataResponse.data else {
                print("Failed to get data in \(#function)")
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                print(searchResponse)
                completion(searchResponse)
            } catch {
                print("Failed to decode in \(#function) -> \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
