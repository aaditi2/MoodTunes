import SwiftUI

struct MoodMapView: View {
    let days = Array(1...30)
    
    var body: some View {
        ScrollView {
            Text("🗓 Your MoodMap")
                .font(.title)
                .bold()
                .padding(.top)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                ForEach(days, id: \.self) { day in
                    VStack {
                        Text("Day \(day)")
                            .font(.caption2)
                            .foregroundColor(.white)

                        Circle()
                            .fill(randomColor(for: day))
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    func randomColor(for day: Int) -> Color {
        let colors: [Color] = [.red, .blue, .pink, .orange, .purple, .green]
        return colors[day % colors.count]
    }
}
