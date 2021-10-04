//
//  CountdownCollectionView.swift
//  countdown
//
//  Created by Guille on 2/10/21.
//

import SwiftUI

struct CountdownCollectionView: View {
  @ObservedObject var countdownCollection = CountdownCollection()
  @State var formIsOpen = false
  var body: some View {
    NavigationView {
      // List all the current timers
      List {
        ForEach(countdownCollection.countdowns) { countdown in
          NavigationLink(countdown.name, destination: CountdownView(countdown: countdown))
        }
      }
      .listStyle(PlainListStyle())
      .navigationBarTitle(Text("Your Timers"))
      .toolbar(content: {
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
          Button(action: {
            // Open new form
            formIsOpen.toggle()
          }, label: {
            Image(systemName: "plus").imageScale(.large)
          })
        }
      })
      .sheet(isPresented: $formIsOpen, content: {
        CountdownFormView(isPresented: $formIsOpen).environmentObject(countdownCollection)
      })
    }

  }
  
  
  struct CountdownFormView: View {
    @State var timerName = ""
    @State var timerEndDate: Date = Date()
    @EnvironmentObject var countdownCollection: CountdownCollection
    @Binding var isPresented: Bool
    var body: some View {
      VStack {
        Form {
          Section(header: Text("Timer Detials")) {
            TextField("Timer Name", text: $timerName)
            DatePicker("End Date", selection: $timerEndDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
          }
          Section(header: Text("Timer Color")) {
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
              Color.green
              Color.gray
              Color.red
              Color.orange
              Color.orange
              Color.orange
              Color.orange
              Color.orange
              Color.orange
              Color.orange
            })
            .frame(maxHeight: 100.0)
          }
          Button("Save Timer") {
            // Create the timer
            countdownCollection.createTimer(name: timerName, endDate: timerEndDate)
            // Close the timer
            isPresented = false
          }
          .disabled(timerName.isEmpty || timerEndDate < Date())  // Disable the button to avoid issues
        }
      }
    }
  }
  
}




struct CountdownCollectionView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CountdownCollectionView(countdownCollection: CountdownCollection())
    }
  }
}
