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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    func set(with model: TrackCellViewModel) {
        trackNameLabel.text = model.trackName
        collectionNameLabel.text = model.collectionName
        artistNameLabel.text = model.artistName
        trackImageView.set(imageURL: model.iconUrlString)
    }
}
