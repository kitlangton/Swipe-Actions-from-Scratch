import SwiftUI
import Wave

struct FluidSwipeActionsView<Content: View>: View {
  init(
    actions: [Action],
    @ViewBuilder content: () -> Content
  ) {
    self.actions = actions
    self.content = content()
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
            actionButton(action: action, index: index)
          }
        }
        .animation(.spring, value: isTriggered)
        .onChange(of: isTriggered) {
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
      }
      .highPriorityGesture(dragGesture)
      .onAppear {
        offsetAnimator.value = offset
        offsetAnimator.valueChanged = {
          offset = $0
        }
      }
  }

  private let actions: [Action]
  private let content: Content

  @State private var offset: CGFloat = 0
  @State private var offsetAnimator =
    SpringAnimator<CGFloat>(spring: .defaultAnimated)

  @State private var startOffset: CGFloat = 0
  @State private var isDragging = false
  @State private var isTriggered = false

  private let triggerThreshhold: CGFloat = -250
  private let expansionThreshhold: CGFloat = -60

  private var expansionOffset: CGFloat { CGFloat(actions.count) * -60 }

  private var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        if !isDragging {
          startOffset = offset
          isDragging = true
        }

        offsetAnimator.target = startOffset + value.translation.width
        offsetAnimator.mode = .nonAnimated
        offsetAnimator.start()

        isTriggered = offset < triggerThreshhold
      }
      .onEnded { value in
        isDragging = false

        if value.predictedEndTranslation.width < expansionThreshhold &&
          !isTriggered
        {
          offsetAnimator.target = expansionOffset
        } else {
          if let action = actions.last, isTriggered {
            action.action()
          }
          offsetAnimator.target = 0
        }
        offsetAnimator.velocity = value.velocity.width * 4
        offsetAnimator.mode = .animated
        offsetAnimator.start()

        isTriggered = false
      }
  }

  @ViewBuilder
  private func actionButton(action: Action, index: Int) -> some View {
    let proportion = CGFloat(actions.count - index)
    let isDefault = index == actions.count - 1
    let width = isDefault && isTriggered ? -offset : -offset * proportion / CGFloat(actions.count)

    ActionButton(
      action: action,
      width: width,
      dismiss: { withAnimation { offset = 0 } }
    )
  }
}

#Preview {
  FluidSwipeActionsView(actions: [
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
