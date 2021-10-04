//
//  CountdownView.swift
//  countdown
//
//  Created by Guille on 28/09/21.
//

import SwiftUI
import Combine

struct CountdownView: View {
  @ObservedObject var countdownViewModel: CountdownViewModel
  
  var countdownCancellable: AnyCancellable?
  
  var timer: Publishers.Autoconnect<Timer.TimerPublisher>

  @State var components = (0,0,0,0)

  init(countdown: Countdown) {
    // Assign the ViewModel
    self.countdownViewModel = CountdownViewModel(countdown: countdown)
    // Start the timer
    self.timer = Timer.publish(every: 1, on: .main, in: .default)
      .autoconnect()
  }

  var body: some View {
    VStack {
      Text(countdownViewModel.countdown.name)
        .font(.title)
      ZStack {
        Text("\(components.0)D \(components.1)H \(components.2)M \(components.3)S")
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .onAppear(perform: {
      calculateDate(with: Date())
    })
    .onReceive(timer, perform: { date in
      calculateDate(with: date)
    })
  }
  
  func calculateDate(with date: Date) {
    let diffComponents = Calendar.current.dateComponents([.day, .second,.minute, .hour], from: date, to: countdownViewModel.countdown.endDate)
    components.0 = diffComponents.day ?? 0
    components.1 = diffComponents.hour ?? 0
    components.2 = diffComponents.minute ?? 0
    components.3 = diffComponents.second ?? 0
  }
}

struct CountdownView_Previews: PreviewProvider {
  static var previews: some View {
    CountdownView(countdown: Countdown(name: "Guillermo Counter", endDate: Date(timeIntervalSinceNow: 3600 * 48)))
  }
}
