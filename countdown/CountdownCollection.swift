//
//  CountdownCollection.swift
//  countdown
//
//  Created by Guille on 2/10/21.
//
import Foundation
import Combine

class CountdownCollection: ObservableObject {
  @Published var countdowns: [Countdown]
  
  init() {
    self.countdowns = [Countdown(name: "Guillermo Counter", endDate: Date(timeIntervalSinceNow: 3600 * 48))]
  }
  
  func createTimer(name: String, endDate: Date) {
    self.countdowns.append(Countdown(name: name, endDate: endDate))
  }
}
