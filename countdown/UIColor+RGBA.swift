//
//  UIColor+RGBA.swift
//  countdown
//
//  Created by Guille on 5/10/21.
//

import SwiftUI


extension UIColor {
  
  public struct RGB: Hashable, Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
  }
  
  // Initialize color from RGBA
  convenience init(_ rgba: RGB) {
    self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
  }
  
  // convert to RGBA
  public var rgba: RGB {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return RGB(red: red, green: green, blue: blue, alpha: alpha)
  }
  
}

// Initialize Color using RGB
extension Color {
  init(_ rgba: UIColor.RGB) {
    self.init(UIColor(rgba))
  }
}
