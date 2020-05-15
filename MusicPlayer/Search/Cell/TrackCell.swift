//
//  TrackCell.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 10.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String? { get }
}

class TrackCell: UITableViewCell {

    static let reuseId = "TrackCell"
    @IBOutlet weak var trackImageView: WebImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var addTrackButton: UIButton!
    
    var cell: SearchViewModel.Cell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    @IBAction func addTrackAction(_ sender: UIButton) {
        guard let cell = cell else { return }
        addTrackButton.isHidden = true
        let defaults = UserDefaults.standard
        var listOfTracks = defaults.savedTracks()
        listOfTracks.append(cell)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
        }
    }
    
    func set(with model: SearchViewModel.Cell) {
        cell = model
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavorite = savedTracks.firstIndex
        { $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName } != nil
        if hasFavorite {
            addTrackButton.isHidden = true
        } else {
            addTrackButton.isHidden = false
        }
        trackNameLabel.text = model.trackName
        collectionNameLabel.text = model.collectionName
        artistNameLabel.text = model.artistName
        trackImageView.set(imageURL: model.iconUrlString)
    }
}
