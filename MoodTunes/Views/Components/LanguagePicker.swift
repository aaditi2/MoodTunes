import SwiftUI

struct LanguagePicker: View {
    let allLanguages: [String]
    @Binding var selectedLanguages: Set<String>

    var body: some View {
        Menu {
            ForEach(allLanguages, id: \.self) { language in
                Button(action: {
                    if selectedLanguages.contains(language) {
                        selectedLanguages.remove(language)
                    } else {
                        selectedLanguages.insert(language)
                    }
                }) {
                    Label(language, systemImage: selectedLanguages.contains(language) ? "checkmark.circle.fill" : "circle")
                }
            }
        } label: {
            Label("Languages", systemImage: "globe")
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}
