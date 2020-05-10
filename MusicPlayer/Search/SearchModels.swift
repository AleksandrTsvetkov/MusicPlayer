//
//  SearchModels.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 07.05.2020.
//  Copyright (c) 2020 Александр Цветков. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case some
        case getSearchResults(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
        case presentSearchResults(searchResponse: SearchResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
        case displaySearchResults(searchResults: SearchViewModel)
      }
    }
  }
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String?
        var artistName: String
        let previewUrl: String?
    }
    let cells: Array<Cell>
}
