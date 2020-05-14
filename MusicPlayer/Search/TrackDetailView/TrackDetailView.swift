//
//  TrackDetailView.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 11.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol PlaylistNavigationDelegate: class {
    func switchToPreviousTrack() -> SearchViewModel.Cell?
    func switchToNextTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    //MARK: OUTLETS
    @IBOutlet weak var trackImageView: WebImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    @IBOutlet weak var miniNextTrackButton: UIButton!
    @IBOutlet weak var miniTrackImageView: WebImageView!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet var fullScreenView: [UIView]!
    
    
    //MARK: PROPERTIES
    let avPlayer: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    private let mpVolumeView = MPVolumeView()
    
    weak var playlistDelegate: PlaylistNavigationDelegate!
    weak var transitionDelegate: TrackDetailViewTransitionDelegate!
    
    //MARK: INITIAL SETUP
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        trackImageView.layer.cornerRadius = 5
        if let view = mpVolumeView.subviews.first as? UISlider {
            volumeSlider.value = view.value
        }
        NotificationCenter.default.addObserver(self, selector: #selector(volumeDidChange), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        miniTrackTitleLabel.text = viewModel.trackName
        artistTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        trackImageView.set(imageURL: string600)
        miniTrackImageView.set(imageURL: string600)
        monitorStartTime()
        observePlayerCurrentTime()
    }
    
    //MARK: FUNCTIONS
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
    
    @objc private func volumeDidChange() {
        if let view = mpVolumeView.subviews.first as? UISlider {
             volumeSlider.value = view.value
        }
    }
    
    //MARK: TIME SETUP
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times: Array<NSValue> = [NSValue(time: time)]
        avPlayer.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
            self?.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self?.miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.convertToString()
            let durationTime = self?.avPlayer.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).convertToString()
            self?.durationLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(avPlayer.currentTime())
        let durationSeconds = CMTimeGetSeconds(avPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let timeRatio = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(timeRatio)
    }
    
    //MARK: ANIMATIONS
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = .identity
        })
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
    //MARK: ACTIONS
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.transitionDelegate.minimizeTrackDetailView()
        //self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
        guard let duration = avPlayer.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = durationInSeconds * Float64(currentTimeSlider.value)
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        avPlayer.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
        //avPlayer.volume = volumeSlider.value
        if let view = mpVolumeView.subviews.first as? UISlider {
             view.value = volumeSlider.value
        }
    }
    
    @IBAction func previousTrack(_ sender: UIButton) {
        guard let cellViewModel = playlistDelegate.switchToPreviousTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            avPlayer.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            reduceTrackImageView()
        }
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
        guard let cellViewModel = playlistDelegate.switchToPreviousTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
}
