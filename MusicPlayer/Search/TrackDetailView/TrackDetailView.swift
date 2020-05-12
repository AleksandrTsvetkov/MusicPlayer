//
//  TrackDetailView.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 11.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import AVFoundation

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: WebImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let avPlayer: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        artistTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        trackImageView.set(imageURL: string600)
    }
    
    private func playTrack(previewUrl: String?) {
        guard
            let urlString = previewUrl,
            let url = URL(string: urlString)
            else {
                print("Failed to get URL in \(#function)")
                return
        }
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
    }
    
    @IBAction func handleVolumeTimer(_ sender: UISlider) {
    }
    
    @IBAction func previousTrack(_ sender: UIButton) {
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            avPlayer.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
    }
    
}
