//
//  SwipeActionsFromScratchApp.swift
//  SwipeActionsFromScratch
//
//  Created by Kit Langton on 9/17/23.
//

import SwiftData
import SwiftUI

@main
struct SwipeActionsFromScratchApp: App {
  @State var currentTab = 0

  var body: some Scene {
    WindowGroup {
      TabView(selection: $currentTab) {
        DefaultSwipeActionsView()
          .tag(0)
          .tabItem {
            Label("Default", systemImage: "list.bullet")
          }

        SwipeActionsView(actions: [
          Action(color: .indigo, name: "Like", systemIcon: "hand.thumbsup.fill", action: {
            print("LIKE")
          }),
          Action(color: .blue, name: "Subscribe", systemIcon: "figure.mind.and.body", action: {
            print("SUBSCRIBE")
          }),
        ]) {
          Text("**THANKS FOR WATCHING**").font(.title)
        }
        .tag(1)
        .tabItem {
          Label("Custom", systemImage: "list.bullet")
        }
      }
    }
  }
}
