//
//  CountdownViewModel.swift
//  countdown
//
//  Created by Guille on 28/09/21.
//

import Foundation

class CountdownViewModel: ObservableObject {
  @Published private(set) var countdown: Countdown
  
  init(countdown: Countdown) {
    self.countdown = countdown
  }
  
}
