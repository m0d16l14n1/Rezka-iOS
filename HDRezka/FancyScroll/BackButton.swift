import SwiftUI

struct BackButton: View {
    let color: Color

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State private var hasBeenShownAtLeastOnce: Bool = false

    var body: some View {
        (presentationMode.wrappedValue.isPresented || hasBeenShownAtLeastOnce) ?
            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
               Image(systemName: "chevron.left")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(height: 18, alignment: .leading)
                   .foregroundColor(color)
                   .padding(.horizontal, 18)
                   .font(.system(size: 16, weight: .semibold))
                   .background {
                       Circle()
                           .frame(height: 30)
                           .foregroundStyle(.ultraThinMaterial)
                   }
            }
            .onAppear {
                self.hasBeenShownAtLeastOnce = true
            }
        : nil
    }
}
