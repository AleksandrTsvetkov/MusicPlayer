//
//  SearchMusicViewController.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 03.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import Alamofire

class SearchMusicViewController: UITableViewController {
    
    private var timer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)
    private var networkService = NetworkService()
    private var trackList: Array<TrackModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupSearchBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(trackList[indexPath.row].trackName)\n\(trackList[indexPath.row].artistName)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkService.fetchTracks(searchText: searchText) { [weak self] response in
                guard let response = response else {
                    print("Search response is nil in \(#function)")
                    return
                }
                self?.trackList = response.results
                self?.tableView.reloadData()
            }
        })
    }
}
