//
//  CountdownView.swift
//  countdown
//
//  Created by Guille on 28/09/21.
//

import SwiftUI

struct CountdownView: View {
    var body: some View {
      VStack {
        Text("Countdown Title")
          .font(.title)
        ZStack {
          Text("50D 20H 20M 20S")
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}
