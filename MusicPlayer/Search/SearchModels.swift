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
        case getSearchResults(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentSearchResults(searchResponse: SearchResponse?)
        case presentFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displaySearchResults(searchResults: SearchViewModel)
        case displayFooterView
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
