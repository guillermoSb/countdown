//
//  Countdown.swift
//  countdown
//
//  Created by Guille on 28/09/21.
//

import SwiftUI

struct Countdown: Codable, Identifiable, Equatable {
  let id = UUID()
  var name:     String  // Name for the countdown
  var endDate:  Date    // Date when the countdown ends
  var startDate: Date
  
  var rgba: UIColor.RGB // RGBA Color for this timer
  
  init(name: String, endDate: Date, rgba: UIColor.RGB) {
    self.name = name
    self.endDate = endDate
    self.rgba = rgba
    self.startDate = Date() // Set the start date to the current date
  }
  
  var active: Bool {
    return Date().timeIntervalSinceReferenceDate < endDate.timeIntervalSinceReferenceDate
  }
  
  var json: Data? {
    return try? JSONEncoder().encode(self)
  }
}

// Color variable to use on views
extension Countdown {
  var color: Color {
    Color(rgba)
  }
}
