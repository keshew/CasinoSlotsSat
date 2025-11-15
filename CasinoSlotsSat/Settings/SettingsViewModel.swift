import SwiftUI

class SettingsViewModel: ObservableObject {
    let contact = SettingsModel()
    
    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
            //            soundManager.toggleMusic()
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    @Published var isSoundOn: Bool {
        didSet {
            //            soundManager.toggleSound()
            UserDefaults.standard.set(isSoundOn, forKey: "isSoundOn")
        }
    }
    
    init() {
        self.isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        self.isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
    }
}
