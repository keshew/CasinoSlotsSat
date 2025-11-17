import SwiftUI

class SettingsViewModel: ObservableObject {
    let contact = SettingsModel()
    
    @ObservedObject private var soundManager = SoundManager.shared
    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
            soundManager.toggleMusic()
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    @Published var isSoundOn: Bool {
        didSet {
            soundManager.toggleSound()
            UserDefaults.standard.set(isSoundOn, forKey: "isSoundOn")
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    
    init() {
        self.isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        self.isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
    }
}
