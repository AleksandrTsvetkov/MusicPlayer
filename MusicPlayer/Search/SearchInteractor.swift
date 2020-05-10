//
//  SearchInteractor.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 07.05.2020.
//  Copyright (c) 2020 Александр Цветков. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {

  private var networkService = NetworkService()
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    
    switch request {
    case .some:
        print("interactor .some")
    case .getSearchResults(let searchText):
        print("interactor .getTracks")
        networkService.fetchTracks(searchText: searchText) { [weak self] (searchResponse) in
            self?.presenter?.presentData(response: .presentSearchResults(searchResponse: searchResponse))
        }
        
    }
  }
  
}
