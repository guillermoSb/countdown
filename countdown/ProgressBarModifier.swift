//
//  ProgressBar.swift
//  countdown
//
//  Created by Guille on 6/10/21.
//

import SwiftUI

struct ProgressBarModifier: AnimatableModifier {
  
  var height: CGFloat
  var width: CGFloat
  
  var animatableData: CGFloat {
    get {self.height}
    set {self.height = newValue}
  }
  
  func body(content: Content) -> some View {
    return content.frame(width: width, height: height)
  }
}


extension View {
  func progressBarModifier(width: CGFloat, height: CGFloat) -> some View {
    self.modifier(ProgressBarModifier(height: height, width: width))
  }
}
