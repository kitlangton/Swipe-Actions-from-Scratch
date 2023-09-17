//
//  ActionButton.swift
//  SwipeActionsFromScratch
//
//  Created by Kit Langton on 9/20/23.
//

import SwiftUI

struct ActionButton: View {
  let action: Action
  var width: CGFloat
  var dismiss: () -> Void

  var body: some View {
    Button {
      action.action()
      dismiss()
    } label: {
      action.color
        .overlay(alignment: .leading) {
          Label(action.name, systemImage: action.systemIcon)
            .labelStyle(.iconOnly)
            .padding(.leading)
        }
        .clipped()
        .frame(width: width)
        .font(.title2)
    }.buttonStyle(.plain)
  }
}

struct Action {
  let color: Color
  let name: String
  let systemIcon: String
  let action: () -> Void
}
