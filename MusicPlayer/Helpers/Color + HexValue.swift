//
//  Color + HexValue.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 15.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex: String) {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) { cString.removeFirst() }

    if ((cString.count) != 6) {
      self.init(hex: "ff0000") // return red color for wrong hex input
      return
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    self.init(red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: Double(rgbValue & 0x0000FF) / 255.0)
  }

}
