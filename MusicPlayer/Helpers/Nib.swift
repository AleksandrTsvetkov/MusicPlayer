//
//  Nib.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 13.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
    }
}
