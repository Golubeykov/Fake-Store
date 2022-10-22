//
//  ColorsStorage.swift
//  Fake Store
//
//  Created by Антон Голубейков on 27.09.2022.
//

import UIKit

class ColorsStorage {
    static let backgroundBlue: UIColor = UIColor(rgb: 0x6EE8FB)
    static let clear = UIColor.clear
    static let white = UIColor(rgb: 0xFFFFFF)
    static let black = UIColor(rgb: 0x000000)
    static let red = UIColor(rgb: 0xF35858)
    static let lightGray = UIColor(rgb: 0xB0B0B0)
    static let backgroundGray = UIColor(rgb: 0xD9D9D9)
    static let lightTextGray = UIColor(rgb: 0xDFDFDF)
    static let orange = UIColor(rgb: 0xFDB87D)
    static let gradientBlue = UIColor(rgb: 0x88A7D6)
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
