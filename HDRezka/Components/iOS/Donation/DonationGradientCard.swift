//
//  ThanksGradientCard.swift
//  HDRezka
//
//  Created by keet on 04.11.2023.
//

import SwiftUI

struct DonationGradientCard: View {
    var name: String
    var value: Int
    var message: String
    let colors: [Color] = [
        .orange,
        .blue,
        .purple,
        .red
    ]
    
    @State var gradientAngle: Double = 0
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    if !message.isEmpty {
                        Text(message)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    } else {
                        Text("donationcard_emptymessage")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding()
                
                Spacer()
                
                Text("\(value)₽")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding()
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .padding(.all, 25)
            .onAppear {
                withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                    self.gradientAngle = 360
                }
            }
        }
        .background {
            Rectangle()
                .fill(AngularGradient(gradient: Gradient(colors: colors), center: .center, angle: .degrees(gradientAngle)))
                .brightness(0.2)
                .foregroundStyle(.cyan)
                .frame(width: 330, height: 70)
                .blur(radius: 20)
        }
    }
}

#Preview {
    DonationGradientCard(name: "4nk1r", value: 1000, message: "")
}
