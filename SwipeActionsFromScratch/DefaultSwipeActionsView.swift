import SwiftData
import SwiftUI

struct DefaultSwipeActionsView: View {
  var body: some View {
    List {
      Text("HELLO. I AM NORMAL LIST ITEM.")
        .font(.headline)
        .padding(.vertical)
        .swipeActions {
          Button(action: {
            print("DEFAULT")
          }, label: {
            Image(systemName: "sparkles")
          })
          .tint(.blue)

          Button(action: {
            print("TRASH")
          }, label: {
            Image(systemName: "trash.fill")
          })
          .tint(.red)
        }
    }
    .padding(.top, 300)
  }
}

#Preview {
  DefaultSwipeActionsView()
}
