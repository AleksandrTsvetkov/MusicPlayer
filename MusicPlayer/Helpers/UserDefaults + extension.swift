//
//  UserDefaults + extension.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 15.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoriteTrackKey = "favoriteTrackKey"
    
    func savedTracks() -> Array<SearchViewModel.Cell> {
        let defaults = UserDefaults.standard
        guard
            let savedTracks = defaults.object(forKey: UserDefaults.favoriteTrackKey) as? Data,
            let decodedTracks = try?
                NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks)
                as? Array<SearchViewModel.Cell>
            else { return [] }
        return decodedTracks
    }
}
