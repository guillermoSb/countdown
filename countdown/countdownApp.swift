//
//  countdownApp.swift
//  countdown
//
//  Created by Guille on 28/09/21.
//

import SwiftUI

@main
struct countdownApp: App {
    var body: some Scene {
        WindowGroup {
          CountdownCollectionView(countdownCollection: CountdownCollection())
        }
    }
}
