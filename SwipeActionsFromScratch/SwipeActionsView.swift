import SwiftUI

struct SwipeActionsView<Content: View>: View {
  init(
    actions: [Action],
    @ViewBuilder content: () -> Content
  ) {
    self.actions = actions
    self.content = content()
  }

  var content: Content

  @State var offset: CGFloat = 0
  @State var startOffset: CGFloat = 0
  @State var isDragging = false
  @State var isTriggered = false

  let triggerThreshhold: CGFloat = -250
  let expansionThreshhold: CGFloat = -60
  let actions: [Action]

  var expansionOffset: CGFloat { CGFloat(actions.count) * -60 }

  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        if !isDragging {
          startOffset = offset
          isDragging = true
        }

        withAnimation(.interactiveSpring) {
          offset = startOffset + value.translation.width
        }

        isTriggered = offset < triggerThreshhold
      }
      .onEnded { value in
        isDragging = false

        withAnimation {
          if value.predictedEndTranslation.width < expansionThreshhold &&
            !isTriggered
          {
            offset = expansionOffset
          } else {
            if let action = actions.last, isTriggered {
              action.action()
            }
            offset = 0
          }
        }

        isTriggered = false
      }
  }

  var body: some View {
    content
      .offset(x: offset)
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .contentShape(Rectangle())
      .overlay(alignment: .trailing) {
        ZStack(alignment: .trailing) {
          ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
            let proportion = CGFloat(actions.count - index)
            let isDefault = index == actions.count - 1
            let width = isDefault && isTriggered ?
              -offset :
              -offset * proportion / CGFloat(actions.count)

            ActionButton(
              action: action,
              width: width,
              dismiss: { withAnimation { offset = 0 } }
            )
          }
        }
        .animation(.spring, value: isTriggered)
        .onChange(of: isTriggered) {
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
      }
      .highPriorityGesture(dragGesture)
  }
}

#Preview {
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
}
