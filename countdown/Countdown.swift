//
//  Countdown.swift
//  countdown
//
//  Created by Guille on 28/09/21.
//

import Foundation

struct Countdown: Identifiable {
  let id = UUID()
  let name:     String  // Name for the countdown
  let endDate:  Date    // Date when the countdown ends
  
  init(name: String, endDate: Date) {
    self.name = name
    self.endDate = endDate
  }
}
