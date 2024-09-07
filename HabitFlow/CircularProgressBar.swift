import SwiftUI

struct CircularProgressBar: View {
    var progress: Float

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
                .foregroundColor(Color.blue)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0))) // Ensure the progress is between 0.0 and 1.0
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 1.0), value: progress) // Smooth animation
            
            Text(String(format: "%.0f %%", min(self.progress, 1.0) * 100.0))
                .font(.caption)
                .bold()
        }
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
