import Foundation
import SwiftUI

class ShortcutHandler: ObservableObject {
    @Published var searchQuery: String?
    @Published var chatMessage: String?
    @Published var playRequested: Bool = false
}
