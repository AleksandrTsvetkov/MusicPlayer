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

class SearchViewModel: NSObject, NSCoding {
    @objc(_TtCC11MusicPlayer15SearchViewModel4Cell)class Cell: NSObject, NSCoding, Identifiable {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String?
        var artistName: String
        let previewUrl: String?
        
        init(iconUrlString: String?, trackName: String, collectionName: String?, artistName: String, previewUrl: String?) {
            self.iconUrlString = iconUrlString
            self.trackName = trackName
            self.collectionName = collectionName
            self.artistName = artistName
            self.previewUrl = previewUrl
        }
        
        func encode(with coder: NSCoder) {
            coder.encode(iconUrlString, forKey: "iconUrlString")
            coder.encode(trackName, forKey: "trackName")
            coder.encode(collectionName, forKey: "collectionName")
            coder.encode(artistName, forKey: "artistName")
            coder.encode(previewUrl, forKey: "previewUrl")
        }
        
        required init?(coder: NSCoder) {
            iconUrlString = coder.decodeObject(forKey: "iconUrlString") as? String
            trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
            collectionName = coder.decodeObject(forKey: "collectionName") as? String
            artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String
        }
    }
    let cells: Array<Cell>
    
    init(cells: Array<Cell>) {
        self.cells = cells
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }
    
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: "cells") as? Array<SearchViewModel.Cell> ?? []
    }
}
