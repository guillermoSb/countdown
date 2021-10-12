//
//  CountdownCollection.swift
//  countdown
//
//  Created by Guille on 2/10/21.
//
import UIKit
import Combine


class CountdownCollection: ObservableObject {
  @Published var countdowns: [Countdown]
  
  var activeCountdowns: [Countdown] {
    return countdowns.filter {$0.active}
  }
  
  private var autoSaveCancellable: AnyCancellable?
  init() {
    self.countdowns = [] // Empty array of countdowns
    // Try to get the countdowns saved previously
    if let data = UserDefaults.standard.data(forKey: CountdownCollection.countdownKey) {
      self.countdowns = (try? JSONDecoder().decode(Array<Countdown>.self, from: data)) ?? [] // Try to decode the data received
    }
    autoSaveCancellable = $countdowns.sink { countdowns in
      // Save the new data
      let encodedData = try? JSONEncoder().encode(countdowns)
      UserDefaults.standard.setValue(encodedData, forKey: CountdownCollection.countdownKey) // Save the data on user defaults
    }
  }
  
  func createTimer(name: String, endDate: Date, color: UIColor) {
    self.countdowns.append(Countdown(name: name, endDate: endDate, rgba: color.rgba))
  }
  
  func removeCountdown(at index: Int) {
    self.countdowns.remove(at: index);
  }
  
  func updateTimer(_ timer: Countdown, name: String, endDate: Date, color: UIColor) {
    let idx = countdowns.firstIndex(of: timer)
    if let index = idx {
      self.countdowns[index].name = name
      self.countdowns[index].rgba = color.rgba
      self.countdowns[index].endDate = endDate
      if endDate != self.countdowns[index].endDate {
        self.countdowns[index].startDate = Date()
      }
    }
  
  }
  static let countdownKey = "countdownGuilleKey"
}
