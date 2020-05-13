//
//  CMTime + Extension.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 12.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import AVFoundation

extension CMTime {
    func convertToString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}
