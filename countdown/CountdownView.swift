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
  @State var heightMultiplier: Double = 1
  
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
        .font(.largeTitle.weight(.semibold))
      HStack (alignment: .top, spacing: 48.0) {
        VStack(alignment: .leading, spacing: 16.0) {
          VStack(alignment: .leading) {
            Text("\(components.0 < 10 ? "0" : "")\(components.0)").font(.title.bold())
            Text("Days").font(.body)
          }
          VStack(alignment: .leading) {
            Text("\(components.1 < 10 ? "0" : "")\(components.1)").font(.title.bold())
            Text("Hours").font(.body)
          }
          VStack(alignment: .leading) {
            Text("\(components.2 < 10 ? "0" : "")\(components.2)").font(.title.bold())
            Text("Minutes").font(.body)
          }
          VStack(alignment: .leading) {
            Text("\(components.3 < 10 ? "0" : "")\(components.3)").font(.title.bold())
            Text("Seconds").font(.body)
          }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        GeometryReader { geometry in
          ZStack (alignment: .bottom) {
            
            RoundedRectangle(cornerRadius: 10.0)
              .foregroundColor(countdownViewModel.countdown.color).opacity(0.1)
            RoundedRectangle(cornerRadius: 10.0)
              .frame(height: CGFloat(heightMultiplier) * geometry.size.height).foregroundColor(countdownViewModel.countdown.color).opacity(0.8)
          }
          .frame(width: 100.0, height: geometry.size.height)
          
        }.frame(width: 100, alignment: .bottom)
      }
      .fixedSize(horizontal: false, vertical: true)
      .padding(.top, 32.0)
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .padding(.top, 32.0)
    .onAppear(perform: {
      timer.upstream.connect()
      // calculate the first height multiplier
      let totalSeconds = countdownViewModel.countdown.endDate.timeIntervalSinceReferenceDate - countdownViewModel.countdown.startDate.timeIntervalSinceReferenceDate
      heightMultiplier = 1 - min(1, (Date().timeIntervalSinceReferenceDate - countdownViewModel.countdown.startDate.timeIntervalSinceReferenceDate)/totalSeconds)
      // Calculate the animation
      // The duration neeeds to be the date that is left for the timer to finish
      withAnimation(.linear(duration: countdownViewModel.countdown.endDate.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate
      )) {
        heightMultiplier = 0
      }
      calculateDate(with: Date())
    })
    .onDisappear(perform: {
      timer.upstream.connect().cancel()
    })
    .onReceive(timer, perform: { date in
      
      calculateDate(with: date)
    })
  }
  
  func calculateDate(with date: Date) {
    let diffComponents = Calendar.current.dateComponents([.day, .second,.minute, .hour], from: date, to: countdownViewModel.countdown.endDate)
    components.0 = max(diffComponents.day ?? 0, 0)
    components.1 = max(diffComponents.hour ?? 0, 0)
    components.2 = max(diffComponents.minute ?? 0, 0)
    components.3 = max(diffComponents.second ?? 0, 0)
    if components.3 < 0 {
      timer.upstream.connect().cancel()
      components.3 = 0
    }
    
   
  }
}

struct CountdownView_Previews: PreviewProvider {
  static var previews: some View {
    CountdownView(countdown: Countdown(name: "Guillermo Counter", endDate: Date(timeIntervalSinceNow: 11), rgba: UIColor(.red).rgba))
  }
}
