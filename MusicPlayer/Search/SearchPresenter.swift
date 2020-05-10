//
//  SearchPresenter.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 07.05.2020.
//  Copyright (c) 2020 Александр Цветков. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?
    
    func presentData(response: Search.Model.Response.ResponseType) {
        switch response {
        case .some:
            print("presenter .some")
        case .presentSearchResults(let searchResponse):
            print("presenter .presentTracks")
            let cells = searchResponse?.results.map { track in
                cellViewModel(from: track)
            } ?? []
            let searchViewModel = SearchViewModel(cells: cells)
            viewController?.displayData(viewModel: .displaySearchResults(searchResults: searchViewModel))
        }
    }
    
    private func cellViewModel(from trackModel: TrackModel) -> SearchViewModel.Cell {
        return SearchViewModel.Cell(iconUrlString: trackModel.artworkUrl100,
                                    trackName: trackModel.trackName,
                                    collectionName: trackModel.collectionName ?? "",
                                    artistName: trackModel.artistName,
                                    previewUrl: trackModel.previewUrl)
    }
    
}
