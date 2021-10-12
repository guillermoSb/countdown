//
//  CountdownCollectionView.swift
//  countdown
//
//  Created by Guille on 2/10/21.
//

import SwiftUI

struct CountdownCollectionView: View {
  @ObservedObject var countdownCollection = CountdownCollection()
  @State var editMode: EditMode = .inactive
  @State var formIsOpen = false
  @State var editFormIsOpen = false
  
  var body: some View {
    NavigationView {
      // List all the current timers
      List {
        ForEach(countdownCollection.activeCountdowns) { countdown in
          NavigationLink(
            destination:  CountdownView(countdown: countdown),
            label: {
              HStack {
                ZStack {
                  Circle().frame(width: 20, height: 20, alignment: .center).foregroundColor(countdown.color)
                  if editMode.isEditing {
                    Image(systemName: "pencil").imageScale(.small).foregroundColor(.white)
                  }
                }
                .onTapGesture {
                  if editMode.isEditing {
                    // Handle the tap gesture
                    self.editFormIsOpen = true
                  }
                }
                .sheet(isPresented: $editFormIsOpen, content: {
                  // Show the edit form
                  CountdownFormView(isPresented: $editFormIsOpen, countdown: countdown).environmentObject(countdownCollection)
                })
                Text(countdown.name)
                
              }
            })
        }.onDelete(perform: { indexSet in
          // Delete the
          for index in indexSet {
            countdownCollection.removeCountdown(at: index)
          }
        })
      }
      .listStyle(PlainListStyle())
      .navigationBarTitle(Text("Active Timers"))
      .toolbar(content: {
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
          EditButton()
        }
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
          Button(action: {
            // Open new form
            formIsOpen.toggle()
          }, label: {
            Image(systemName: "plus").imageScale(.large)
          })
        }
      })
      .environment(\.editMode, $editMode)
      .sheet(isPresented: $formIsOpen, content: {
        CountdownFormView(isPresented: $formIsOpen).environmentObject(countdownCollection)
      })
    }
    
    
  }
  
  
  struct CountdownFormView: View {
    @State var timerName = ""
    @State var timerEndDate: Date = Date()
    @State var selectedColor: Color = .red
    @EnvironmentObject var countdownCollection: CountdownCollection
    @Binding var isPresented: Bool
    var countdown: Countdown?
    var editMode: Bool {
      return countdown != nil
    }
    
    let possibleColors: [Color] = [.red, .orange, .green, .yellow, .blue, .purple]
    var body: some View {
      VStack {
        Form {
          Section(header: Text("Timer Detials")) {
            TextField("Timer Name", text: $timerName)
            DatePicker("End Date", selection: $timerEndDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
          }
          Section(header: Text("Timer Color")) {
            ScrollView(.vertical,showsIndicators: false) {
              LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: gridSpacing) {
                ForEach(possibleColors, id: \.self) { color in
                  ZStack {
                    RoundedRectangle(cornerRadius: rectangleRadius).frame(height: colorHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(color)
                    // Show the checkmark only for thee selected color
                    if (UIColor(selectedColor).rgba == UIColor(color).rgba) {
                      Image(systemName: "checkmark.circle").imageScale(.large).font(.title.weight(.bold)).foregroundColor(.white)
                    }
                  }
                  .onTapGesture {
                    // set the selected color as this color
                    selectedColor = color
                  }
                }
              }
            }.frame(height: scrollViewHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          }
          Button("Save Timer") {
            if !editMode {
              // Create the timer
              countdownCollection.createTimer(name: timerName, endDate: timerEndDate, color: UIColor(selectedColor))
            } else if let timer = countdown {
              countdownCollection.updateTimer(timer, name: timerName, endDate: timerEndDate, color: UIColor(selectedColor))
            }
            
            // Close the timer
            isPresented = false
          }
          .disabled(timerName.isEmpty || timerEndDate < Date())  // Disable the button to avoid issues
        }
      }.onAppear {
        if editMode {
          self.timerName = self.countdown?.name ?? ""
          self.selectedColor = self.countdown?.color ?? .red
          self.timerEndDate = self.countdown?.endDate ?? Date()
        }
      }
    }
    
    
    
    
    private let rectangleRadius: CGFloat = 10.0
    private let gridSpacing: CGFloat = 10.0
    private let scrollViewHeight: CGFloat = 150.0
    private let colorHeight: CGFloat = 50.0
  }
  
}




struct CountdownCollectionView_Previews: PreviewProvider {
  static var previews: some View {

    let countdownCollection = CountdownCollection()
    countdownCollection.createTimer(name: "Guillermo Test", endDate: Date().addingTimeInterval(60), color: .red)
    return CountdownCollectionView(countdownCollection: countdownCollection)
    
  }
}
