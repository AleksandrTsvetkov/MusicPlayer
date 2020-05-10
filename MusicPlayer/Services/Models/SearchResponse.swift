//
//  SearchResponse.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 07.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: Array<TrackModel>
}

struct TrackModel: Decodable {
    let artistName: String
    let trackName: String
    let collectionName: String?
    let artworkUrl100: String?
    let previewUrl: String?
}
