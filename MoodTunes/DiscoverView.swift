import SwiftUI

struct DiscoverView: View {
    @State private var searchText = ""
    @State private var suggestions = ["Songs for when you're ghosted 👻", "Rainy day lo-fi 🌧", "Hindi heartbreak", "Shreya Ghoshal feels", "Revenge songs", "Tamil sad songs"]

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by vibe, mood, artist...", text: $searchText)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding()

                List {
                    ForEach(filteredSuggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                    }
                }
                .listStyle(.plain)
                .background(Color.black)
            }
            .navigationTitle("🔍 Discover")
            .background(Color.black)
        }
    }

    var filteredSuggestions: [String] {
        if searchText.isEmpty {
            return suggestions
        } else {
            return suggestions.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
}
