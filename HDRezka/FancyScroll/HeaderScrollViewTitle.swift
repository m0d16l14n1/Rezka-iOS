import SwiftUI

struct HeaderScrollViewTitle: View {
    let title: String
    let titleColor: Color
    let height: CGFloat
    let largeTitle: Double

    var body: some View {
        let largeTitleOpacity = (max(largeTitle, 0.5) - 0.5) * 2
        let tinyTitleOpacity = 1 - min(largeTitle, 0.5) * 2
        return ZStack {
            ZStack(alignment: .bottom) {
         
              
            }
            .padding(.bottom, 8)
            .opacity(sqrt(largeTitleOpacity))
     

            ZStack {
                HStack {
                    BackButton(color: .primary)
                    Spacer()
                    ShareButton(color: .primary)
                }
                HStack {
                    Text(title)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                      
                    
                }
            }
            .padding(.bottom, (height-18) / 2)
            .opacity(sqrt(tinyTitleOpacity))
        }.frame(height: height)
    }
}
